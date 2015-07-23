require 'chaucer'

class Server < ActiveRecord::Base

  Error = Class.new(StandardError)

  STATES = [
    "stopped",
    "starting",
    "running",
    "pausing",
    "paused",
    "stopping",
    "suspending",
    "suspended",
    "resuming",
  ]

  belongs_to :template, class_name: 'Server'
  belongs_to :host
  belongs_to :account
  belongs_to :zone
  belongs_to :appliance
  belongs_to :bundle
  belongs_to :base, class_name: 'Server'
  belongs_to :current, class_name: 'Server'

  has_many :volumes, :dependent => :destroy
  has_many :attachments, class_name: 'ServerVolume', :dependent => :destroy
  has_many :addresses, :dependent => :nullify

  validates :name, presence: true
  validates :password, presence: true, allow_nil: true, length: { is: 8 }

  after_initialize if: :new_record? do
    self.name ||= Chaucer.server_name
    self.affinity_group ||= 0
    self.state ||= 'stopped'
    self.password ||= SecureRandom.base64(6)
  end

  after_initialize do
    self.cores ||= 1
    self.memory ||= 1024
    self.storage ||= 20
    self.machine_type ||= 'pc'
    self.boot_order ||= 'cdn'
  end

  before_create do
    self.state = 'suspended' if template and (template.state == 'running' or template.state == 'paused')
  end

  after_create do
    if template
      template.api.suspend(tag: id.to_s) if suspended = (template.state == 'running' or template.state == 'paused')
      volumes.each do |vol|
        vol.realize if vol.base
      end
      template.api.unpause if suspended
    end
  end

  before_save do
    #realize_storage
  end

  def suspend (tag = id)
    raise Error.new("Server isn't running") unless state == 'running' or state == 'paused'
    transaction do |tx|
      self.state = 'suspended'
      save!
      api.suspend(tag: tag.to_s)
      api.stop
    end
  end

  def resume (tag = id)
    raise Error.new("Server isn't suspended") if tag && state != 'suspended'
    start(resume: tag)
  end

  def migration_port
    20000 + id
  end

  def migrate (new_host)
    raise Error.new("Server isn't running or paused") if state != 'running' && state != 'paused'
    old_api = api
    self.state = 'stopped'
    self.host = new_host
    start(migrate: true)
    old_api.migrate_to(host: new_host.address.to_s, port: migration_port)
  end

  def start (resume: false, migrate: false)
    raise Error.new("Server isn't stopped") unless state == 'stopped' or state == 'suspended'
    transaction do |tx|
      assign_host unless host
      realize_storage
      allocate_address
      self.state = 'running'
      save!
      if resume
        api.resume(tag: tag.to_s, config: config)
      elsif migrate
        api.migrate_from(host: host.address.to_s, port: migration_port, config: config)
      else
        api.start(config: config)
      end
    end
  end

  def pause
    raise Error.new("Server isn't running") unless state == 'running'
    transaction do |tx|
      self.state = 'paused'
      save!
      api.pause
    end
  end

  def unpause
    raise Error.new("Server isn't paused") unless state == 'paused'
    transaction do |tx|
      self.state = 'running'
      save!
      api.unpause
    end
  end

  def stop
    raise Error.new("Server isn't running or paused") unless state == 'running' or state == 'paused'
    transaction do |tx|
      self.state = 'stopped'
      api_ = api
      self.host = nil
      save!
      api_.stop
    end
  end

  def reset
    raise Error.new("Server isn't running or paused") unless state == 'running' or state == 'paused'
    transaction do |tx|
      api.reset
    end
  end

  def clone (**attrs)
    transaction do |tx|
      s = Server.new(name: name.succ, template: self)
      %i"cores memory storage affinity_group appliance_data account_id zone_id appliance_id bundle_id machine_type boot_order".each do |field|
        s[field] = attrs[field] || self[field]
      end
      map = {}
      volumes.each do |vol|
        nvol = vol.clone
        s.volumes << nvol
        map[vol.id] = nvol
      end
      attachments.each do |att|
        s.attachments << ServerVolume.new(attachment: att.attachment,
                                          volume: map[att.volume.id] || att.volume)
      end
      s
    end
  end

  def vnc_address
    raise "Server isn't running or paused" unless state == 'running' or state == 'paused'
    [host.address.to_s, id + 5900]
  end

  def vnc_password
    password
  end

  def websocket_path
    "vnc/#{vnc_address}"
  end

  def iso_attachment
    attachments.joins(:volume).where(volumes: {optical: true}).first
  end

  def iso
    iso_attachment && iso_attachment.volume
  end

  def iso_id
    iso && iso.id
  end

  def iso_id= (id)
    if id.to_i == 0
      attachments.joins(:volume).where(volumes: {optical: true}).delete_all
    elsif i = iso_attachment
      i.update! volume_id: id
    else
      attachments.new(volume: Volume.find(id), attachment: 'cdrom')
    end
  end

  def root_attachment
    attachments.joins(:volume).where(volumes: {optical: false}).first
  end

  def root
    root_attachment && root_attachment.volume
  end

  def root_id
    root && root.id
  end

  def config
    {
      memory: memory,
      cores: cores,
      display: id,
      ports: [
        {
          mac: generate_mac(0),
          net: ipv4_address.subnet.network.bridge,
          if: "vm#{id}i0"
        },
      ],
      password: vnc_password,
      type: machine_type,
      boot_order: boot_order,
      name: name,
      cd: iso && iso.config,
      hd: root && root.config,
      guest_data: guest_data,
    }
  end

  def api
    host.api(instance: id)
  end

  def ipv4_address
    addresses.joins(:subnet).find_by(subnets: { kind: 'IPv4' })
  end

  def ipv6_address
    addresses.joins(:subnet).find_by(subnets: { kind: 'IPv6' })
  end

  def effective_zone
    zone ? zone : account ? account.zone : nil
  end

  private

  def allocate_address
    if !ipv4_address
      effective_zone.networks.first.allocate_address('IPv4', server: self)
    end
    if !ipv6_address
      effective_zone.networks.first.allocate_address('IPv6', server: self)
    end
  end

  def realize_storage
    if !root and self.storage > 0
      volume = Volume.create!(server: self, account: account, size: storage * 1_000_000_000, zone: effective_zone, name: "root")
      attachments.create!(volume: volume, attachment: 'hda')
      volume.realize
    end
    root && root.realize
  end

  def assign_host
    self.host = effective_zone.pick_compute_host
  end

  def guest_data
    {
      ipv4: ipv4_address && {
        address: ipv4_address.ip.to_s,
        prefix:  ipv4_address.subnet.prefix.to_i,
        netmask: ipv4_address.subnet.netmask,
        gateway: ipv4_address.subnet.gateway.to_s,
      },
      ipv6: ipv6_address && {
        address: ipv6_address.ip.to_s,
        prefix:  ipv6_address.subnet.prefix.to_i,
        netmask: ipv6_address.subnet.netmask,
        gateway: ipv6_address.subnet.gateway.to_s,
      },
      hostname: name.downcase.tr('^a-z0-9-', '')
    }
  end

  def generate_mac (index)
    return nil unless id
    fail "Can't have more than 16 interfaces" if index > 15
    h = id << 4 | index
    h |= 0x020000000000
    [h << 16].pack("Q>").unpack("H2" * 6).join(":")
  end

end
