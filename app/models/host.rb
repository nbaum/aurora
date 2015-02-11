class Host < ActiveRecord::Base
  belongs_to :zone
  
  has_many :servers
  has_many :pools, class_name: 'StoragePool'

  scope :storage, -> { where(has_storage: true) }
  scope :compute, -> { where(has_compute: true) }

  def api (args = {})
    zone.api(url, args)
  end

end
