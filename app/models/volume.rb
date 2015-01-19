class Volume < ActiveRecord::Base
  belongs_to :server
  belongs_to :base
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
  end

  after_destroy do
    api.delete()
  end

  def api ()
    pool.host.api(pool: pool.path, path: path)
  end

  def zone= (zone)
    @zone = zone
  end

  def config
    "#{pool.path}/#{path}"
  end

  def allocate
    api.allocate(size: size)
  end

  def wipe
    api.wipe
  end

end
