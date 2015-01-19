class StoragePool < ActiveRecord::Base
  belongs_to :account
  belongs_to :host
  
  has_many :volumes

  def refresh
    host.api.list_volumes(pool: self.path).each do |data|
      v = volumes.where(path: data[:name]).first_or_initialize(ephemeral: false)
      v.optical = !!(data[:name] =~ /\.iso$/)
      v.name ||= v.path
      v.ephemeral = !v.ephemeral
      v.pool = self
      v.size = data[:size]
      v.save!
    end
  end

end
