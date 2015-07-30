class Volume < ActiveRecord::Base
  belongs_to :server
  belongs_to :base, class_name: 'Volume'
  belongs_to :account
  belongs_to :bundle
  belongs_to :pool, class_name: 'StoragePool', foreign_key: 'storage_pool_id'

  has_many :servers, through: :attachments
  has_many :attachments, class_name: 'ServerVolume', dependent: :destroy

  after_initialize if: :new_record? do
    self.size ||= 10
    self.pool = @zone && @zone.pools.first
    self.ephemeral = false
    self.optical = false
    uuid = SecureRandom.uuid
    self.path ||= [*uuid.chars[0, 4], uuid].join("/")
  end

  after_destroy do
    api.delete()
  end

  def name ()
    n = super
    n = "#{server.name}'s #{n}" if server
    n
  end

  def api ()
    pool && pool.host && pool.host.api(pool: pool.path, path: path)
  end

  def zone= (zone)
    @zone = zone
  end

  def full_path ()
    "#{pool.path}/#{path}"
  end

  def config
    {
      path: full_path,
      ephemeral: ephemeral,
      optical: optical
    }
  end

  def clone (**attrs)
    attrs = attributes.merge(attrs).merge("id" => nil, "base_id" => self.id)
    attrs.delete("path")
    v = Volume.new
    attrs.each do |key, value|
      v[key] = value
    end
    v
  end

  def realize
    api.realize(base: base && { pool: base.pool.path, path: base.path }, size: size)
  end

  def wipe
    api.wipe
  end

end
