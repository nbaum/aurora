# Copyright (c) 2016 Nathan Baum

class Host < ActiveRecord::Base

  belongs_to :zone

  has_many :servers
  has_many :pools, class_name: "StoragePool"

  scope :storage, -> { where(has_storage: true, enabled: true) }
  scope :compute, -> { where(has_compute: true, enabled: true) }

  def api (args = {})
    zone.api(url, args)
  end

  def full_name
    "#{name} on #{zone.full_name}"
  end

end
