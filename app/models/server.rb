require 'chaucer'

class Server < ActiveRecord::Base

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

  has_many :attachments, class_name: 'ServerVolume'
  has_many :addresses

  validates :name, presence: true
  validates :password, presence: true, allow_nil: true, length: { is: 8 }

  after_initialize if: :new_record? do
    self.name ||= Chaucer.server_name
    self.affinity_group ||= 0
    self.zone ||= account && account.zone
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

  before_save do
    #allocate_storage
  end

  def start
    raise "Server isn't stopped" unless state == 'stopped'
    transaction do |tx|
      assign_host unless host
      allocate_storage
      allocate_address
      self.state = 'running'
      save!
      api.start(config: config)
    end
  end

  def pause
    raise "Server isn't running" unless state == 'running'
    transaction do |tx|
      self.state = 'paused'
      save!
      api.pause
    end
  end

  def unpause
    raise "Server isn't paused" unless state == 'paused'
    transaction do |tx|
      self.state = 'running'
      save!
      api.unpause
    end
  end

  def stop
    raise "Server isn't running or paused" unless state == 'running' or state == 'paused'
    transaction do |tx|
      self.state = 'stopped'
      api_ = api
      self.host = nil
      save!
      api_.stop
    end
  end

  def reset
    raise "Server isn't running or paused" unless state == 'running' or state == 'paused'
    transaction do |tx|
      api.reset
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
      mac: generate_mac,
      password: vnc_password,
      guest_data: guest_data,
      type: machine_type,
      boot_order: boot_order,
      name: name,
      cd: iso && iso.config,
      hd: root && root.config
    }
  end

  def api
    host.api(instance: id)
  end

  def address
    addresses.first
  end

  private

  def allocate_address
    if !address
      a = zone.networks.first.addresses.unassigned.first
      a.update! server: self
    end
  end

  def allocate_storage
    if !root and self.storage > 0
      volume = Volume.create!(server: self, account: account, size: storage * 1_000_000_000, zone: zone, name: "#{name}'s root", path: "vm#{id}/root")
      attachments.create!(volume: volume, attachment: 'hda')
      volume.allocate
    end
    root && root.allocate
  end

  def assign_host
    self.host = zone.pick_host(self)
  end

  def guest_data
    {
      address: address.ip.to_s,
      prefix: address.network.prefix,
      netmask: address.network.netmask,
      gateway: address.network.gateway,
      hostname: name.downcase.tr('^a-z0-9-', '')
    }
  end

  def generate_mac
    return nil unless id
    h = id #<< 2 | 0x2
    h <<= 4
    h |= 0x020000000000
    [h << 16].pack("Q>").unpack("H2" * 6).join(":")
  end

end
