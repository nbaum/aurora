class Host < ActiveRecord::Base
  belongs_to :zone
  
  has_many :servers
  has_many :pools, class_name: 'StoragePool'

  def api (args = {})
    zone.api(url, args)
  end

end
