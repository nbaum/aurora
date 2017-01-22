# Copyright (c) 2016 Nathan Baum

require "chaucer"

class Server < ActiveRecord::Base

  include Lockable
  include ActionView::Helpers::UrlHelper

  delegate :url_helpers, to: "Rails.application.routes"

  Error = Class.new(StandardError)

  MACHINE_TYPES = {
    "pc"  => "PC (IDE storage)",
    "sas" => "PC (SCSI storage)",
    "virtio" => "PC (VirtIO storage)",
    "vmware" => "PC (Simulated VMware storage)",
    "mac" => "Apple Macintosh",
  }.freeze

  STATES = %w[stopped starting running pausing paused stopping suspending suspended resuming].freeze

  belongs_to :template, class_name: "Server"
  belongs_to :host
  belongs_to :account
  belongs_to :zone
  belongs_to :appliance
  belongs_to :bundle
  belongs_to :base, class_name: "Server"
  belongs_to :current, class_name: "Server"

  has_many :volumes, dependent: :destroy
  has_many :attachments, class_name: "ServerVolume", dependent: :destroy
  has_many :addresses, dependent: :nullify

  validates :name, presence: true
  validates :password, presence: true, allow_nil: true, length: { is: 8 }

  scope :up, -> { where("state = 'running' OR state = 'paused'") }

  after_initialize if: :new_record? do
    self.name ||= Chaucer.server_name
    self.affinity_group ||= 0
    self.state ||= "stopped"
    self.password ||= SecureRandom.base64(6)
    self.networks_id = Network.pluck(:id)
  end

  after_initialize do
    self.cores ||= 1
    self.memory ||= 1024
    self.storage ||= 20
    self.machine_type ||= "pc"
    self.boot_order ||= "cdn"
    self.tags = [] if self.tags == {}
  end

  def script
    super || [{"action" => "stop"}].to_yaml
  end

  before_create do
    self.state = "suspended" if template && template.started?
  end

  after_create do
    if template
      template.api.suspend(tag: id.to_s) if suspended = template.started?
      volumes.each do |vol|
        vol.realize if vol.base
      end
      template.api.unpause if suspended
    end
    account.debit("server", charge, self.name, period = "second")
  end

  def networks
    @networks ||= self['networks_id'].map{|id|Network.find(id) rescue nil}.compact
  end

  def networks= (networks)
    self['networks_id'] = networks.map{|n|Network.find(n)}.map(&:id)
  end

  def tariff
    account.tariff
  end

  def charge
    tariff.core * cores +
      tariff.memory * memory +
      tariff.storage * storage
  end

  def migration_port
    20_000 + id
  end

  def evict
    migrate(pick_host(exclude: host))
  end

  attr_accessor :new_host

  def host
    new_host || super
  end

  def migrate (new_host)
    return if host == new_host
    raise Error, "Server isn't started" unless started?
    raise Error, "Server is pinned" if pinned?
    already_migrating = false
    begin
      self.new_host = new_host
      if api.status == :stopped
        start(migrate: true)
      else
        already_migrating = true
      end
    ensure
      self.new_host = nil
    end
    api.migrate_to(host: new_host.address.to_s, port: migration_port) unless already_migrating
    sleep 0.5 while api.migrate_wait
    api.stop
    update_attributes! host: new_host
  end

  def migrate_status
    api.migrate_status
  end

  def migrate_cancel
    api.migrate_cancel
  end

  def started?
    %w[running paused].member?(state)
  end

  def stopped?
    %w[stopped suspended].member?(state)
  end

  def running?
    state == "running"
  end

  def paused?
    state == "paused"
  end

  def suspended?
    state == "suspended"
  end

  def start (resume: false, migrate: false)
    return if started? && !migrate
    raise Error, "Server isn't stopped" unless stopped? || migrate
    transaction do |_tx|
      self.host ||= pick_host
      self.state = "running"
      realize_storage
      allocate_address
      save!
      if resume
        api.resume(tag: resume.to_s, config: config)
      elsif migrate
        api.migrate_from(host: host.address.to_s, port: migration_port, config: config)
      else
        api.start(config: config)
      end
    end
  end

  def pause
    return if paused?
    raise Error, "Server isn't running" unless state == "running"
    transaction do |_tx|
      self.state = "paused"
      save!
      api.pause
    end
  end

  def unpause
    return if running?
    raise Error, "Server isn't paused" unless state == "paused"
    transaction do |_tx|
      self.state = "running"
      save!
      api.unpause
    end
  end

  def stop
    return if stopped?
    raise Error, "Server isn't started" unless state == "running" || state == "paused"
    transaction do |_tx|
      self.state = "stopped"
      api_ = api
      self.host = nil
      save!
      api_.qmp(execute: "quit") rescue nil
      sleep 0.125
      api_.stop
    end
  end

  def suspend (tag = id)
    return if suspended?
    raise Error, "Server isn't running" unless state == "running" || state == "paused" || state == "suspended"
    transaction do |_tx|
      self.state = "suspended"
      save!
      api.suspend(tag: tag.to_s)
      api.stop
    end
  end

  def resume (tag = id)
    raise Error, "Server isn't suspended" unless suspended?
    start(resume: tag)
  end

  def reset
    if started?
      transaction do |_tx|
        api.reset
      end
    else
      start
    end
  end

  def clone_from (other, **attrs)
    transaction do |_tx|
      %i[cores memory storage affinity_group appliance_data account_id zone_id appliance_id bundle_id machine_type boot_order networks_id].each do |field|
        self[field] = attrs[field] || other[field]
      end
      save!
      map = {}
      other.volumes.each do |vol|
        nvol = vol.clone
        self.volumes << nvol
        map[vol.id] = nvol
      end
      other.attachments.where("volume_id IS NOT NULL").each do |att|
        next unless map[att.volume_id]
        attachments.where(attachment: att.attachment).each do |a|
          a.volume.destroy
          a.destroy
        end
        self.attachments << ServerVolume.new(attachment: att.attachment, volume: map[att.volume.id] || att.volume)
      end
      self
    end
  end

  def clone (**attrs)
    Server.new(name: name.succ, template: self).clone_from(self, **attrs)
  end

  def vnc_address
    raise "Server isn't started" unless started?
    [host.address.to_s, id + 5900]
  end

  def vnc_password
    password
  end

  def websocket_path
    "vnc/#{vnc_address}"
  end

  def iso_attachment
    attachments.joins(:volume).where(volumes: { optical: true }).first
  end

  def iso
    iso_attachment && iso_attachment.volume
  end

  def iso_id
    iso && iso.id
  end

  def iso_id= (id)
    if id.to_i == 0
      attachments.joins(:volume).where(volumes: { optical: true }).delete_all
    elsif i = iso_attachment
      i.update! volume_id: id
    else
      attachments.new(volume: Volume.find(id), attachment: "cdrom")
    end
  end

  def root_attachment
    attachments.joins(:volume).where(volumes: { optical: false }).first
  end

  def root
    root_attachment && root_attachment.volume
  end

  def hda
    hda_id && Volume.find(hda_id)
  end

  def hdb
    hdb_id && Volume.find(hdb_id)
  end

  def hdc
    hdc_id && Volume.find(hdc_id)
  end

  def hdd
    hdd_id && Volume.find(hdd_id)
  end

  def hda_id
    attachments.where(attachment: :hda).first&.volume&.id
  end

  def hdb_id
    attachments.where(attachment: :hdb).first&.volume&.id
  end

  def hdc_id
    attachments.where(attachment: :hdc).first&.volume&.id
  end

  def hdd_id
    attachments.where(attachment: :hdd).first&.volume&.id
  end

  def hda_id= (id)
    return if hda_id == id
    attachments.where(attachment: :hda).destroy_all
    attachments.create! attachment: :hda, volume_id: id
  end

  def hdb_id= (id)
    return if hdb_id == id
    attachments.where(attachment: :hdb).destroy_all
    attachments.create! attachment: :hdb, volume_id: id
  end

  def hdc_id= (id)
    return if hdc_id == id
    attachments.where(attachment: :hdc).destroy_all
    attachments.create! attachment: :hdc, volume_id: id
  end

  def hdd_id= (id)
    return if hdd_id == id
    attachments.where(attachment: :hdd).destroy_all
    attachments.create! attachment: :hdd, volume_id: id
  end

  def root_id
    root && root.id
  end

  def root_id= (id)
    if id.to_i == 0
      attachments.joins(:volume).where(volumes: { optical: false }).delete_all
    elsif i = root_attachment
      i.update! volume_id: id
    else
      attachments.new(volume: Volume.find(id), attachment: "hda")
    end
  end

  def network? (net)
    networks_id.member?(net.id)
  end

  def port_configs
    effective_zone.networks.order(:index).map.with_index do |net, i|
      next unless network?(net)
      {
        addr: net.index + 3,
        mac: generate_mac(i),
        net: net.bridge,
        if: "vm#{id}i#{i}",
      }
    end.compact
  end

  def config
    {
      host: host && host.id,
      state: state,
      memory: memory,
      cores: cores,
      display: id,
      ports: port_configs,
      password: vnc_password,
      boot_order: boot_order,
      name: name,
      cd: iso && iso.config,
      hda: hda&.config,
      hdb: hdb&.config,
      hdc: hdc&.config,
      hdd: hdd&.config,
      guest_data: guest_data,
    }
  end

  def api (host = self.host)
    host.api(instance: id)
  end

  def ipv4_address (network)
    addresses.joins(:subnet).joins(:network).find_by(networks: { id: network.id }, subnets: { kind: "IPv4" })
  end

  def ipv6_address (network)
    addresses.joins(:subnet).joins(:network).find_by(networks: { id: network.id }, subnets: { kind: "IPv6" })
  end

  def effective_zone
    @effective_zone ||= begin
      volumes.each do |vol|
        return @effective_zone = vol.zone if vol.zone
      end
      zone ? zone : account ? account.zone : nil
    end
  end

  def guest_password! (username, password)
    api.qga(execute: "guest-set-user-password", arguments: {username: username, password: Base64.encode64(password), crypted: false})
  end

  def guest_execute! (command, input = "", capture: true)
    args = if Array === command
      { path: command[0], arg: command[1..-1] }
    else
      { path: "/bin/bash", arg: ["-c", command] }
    end
    args["capture-output"] = true if capture
    args["input-data"] = Base64.encode64(input) if input
    pid = api.qga(execute: "guest-exec", arguments: args)["pid"].to_i
    status = nil
    loop do
      status = api.qga(execute: "guest-exec-status", arguments: {pid: pid})
      break if status["exited"] == true
      sleep 0.125
    end
    if status["exitcode"] == 0
      Base64.decode64(status["out-data"] || "").force_encoding("UTF-8").scrub
    else
      fail Base64.decode64(status["out-data"] || "").force_encoding("UTF-8").scrub
    end
  end

  SCANCODE_LOWER_MAP = "\e1234567890-=\b\tqwertyuiop[]\n\001asdfghjkl;'#\002\\zxcvbnm,./\003\004\005 ".freeze
  SCANCODE_UPPER_MAP = "\e!\"£$%^&*()_+\b\tQWERTYUIOP{}\n\001ASDFGHJKL:@~\002|ZXCVBNM<>?\003".freeze

  def sendkeys (string)
    string_to_sendkeys(string).each do |keys|
      api.qmp(execute: "send-key", arguments: {keys: keys})
    end
  end

  def rune_to_sendkey (rune)
    if i = SCANCODE_LOWER_MAP.index(rune)
      [ i + 1 ]
    elsif i = SCANCODE_UPPER_MAP.index(rune)
      [ "shift", i + 1 ]
    else
      fail "No sendkey conversion for `#{rune}'"
    end
  end

  def string_to_sendkeys (string)
    string.chars.map do |c|
      rune_to_sendkey(c).map do |d|
        if String === d
          { type: "qcode", data: d }
        else
          { type: "number", data: d }
        end
      end
    end
  end

  def allocate_address
    effective_zone.networks.order(:index).each do |network|
      unless ipv4_address(network)
        network.allocate_address("IPv4", server: self)
      end
      unless ipv6_address(network)
        network.allocate_address("IPv6", server: self)
      end
    end
  end

  def realize_storage
    if !root && self.storage > 0
      volume = Volume.create!(server: self, account: account, size: storage, zone: effective_zone, name: "root")
      attachments.create!(volume: volume, attachment: "hda")
      volume.realize
    end
    root && root.realize
  end

  def pick_host (exclude: nil)
    effective_zone.pick_compute_host(exclude: exclude)
  end

  def guest_data
    gd = {}
    gd["hostname"] = name.downcase.tr(" ", "-").tr("^a-z0-9-", "")
    effective_zone.networks.order(:index).map.with_index do |net, i|
      ipv4 = ipv4_address(net)
      ipv6 = ipv6_address(net)
      if ipv4
        gd["net#{i}.address"] = ipv4.ip.to_s
        gd["net#{i}.prefix"] = ipv4.subnet.prefix.to_s
        gd["net#{i}.gateway"] = ipv4.subnet.gateway.to_s
      else
        gd["net#{i}.dhcp"] = 1
      end
    end
    gd
  end

  def generate_mac (index)
    return nil unless id
    raise "Can't have more than 16 interfaces" if index > 15
    h = id << 4 | index
    h |= 0x020000000000
    [h << 16].pack("Q>").unpack("H2" * 6).join(":")
  end

end
