require 'chaucer'

class Server < ActiveRecord::Base

  STATUSES = [
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

  validates :name, presence: true
  validates :password, presence: true, allow_nil: true, length: { is: 8 }

  after_initialize do
    self.name ||= Chaucer.server_name
    self.cores ||= 1
    self.memory ||= 512
    self.storage ||= 1000
    self.password ||= SecureRandom.base64(6)
    self.affinity_group ||= 0
    self.zone ||= account && account.zone
    self.status ||= 'stopped'
  end

  def start
    raise "Server isn't stopped" unless status == 'stopped'
    assign_host unless host
    self.status = 'running'
    save!
    api.start
  end

  def pause
    raise "Server isn't running" unless status == 'running'
    self.status = 'paused'
    save!
    api.pause
  end

  def unpause
    raise "Server isn't paused" unless status == 'paused'
    self.status = 'running'
    save!
    api.unpause
  end

  def stop
    raise "Server isn't running or paused" unless status == 'running' or status == 'paused'
    self.status = 'stopped'
    api_ = api
    self.host = nil
    save!
    api_.stop
  end

  def vnc_address
    raise "Server isn't running or paused" unless status == 'running' or status == 'paused'
    "#{host.address}:#{id}"
  end

  def vnc_password
    password
  end

  private

  def assign_host
    self.host = zone.pick_host(self)
  end

  def config
    {
      memory: memory,
      cores: cores,
      storage: storage,
      display: id,
      #iso: "isoimages/#{iso}",
      mac: generate_mac,
      password: vnc_password,
      guest_data: guest_data,
      type: "pc",
    }
  end

  def guest_data
    {
      #ip: ip,
      #keys: User.all.map(&:ssh_key).join("\n"),
      hostname: name.downcase.tr('^a-z0-9-', '')
    }
  end

  def api
    host.api(instance: id, config: config)
  end

  def generate_mac
    return nil unless id
    h = id << 2 | 0x2
    [h].pack("Q").unpack("H2" * 6).join(":")
  end

end
