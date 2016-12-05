# Copyright (c) 2016 Nathan Baum

class StoragePool < ActiveRecord::Base

  belongs_to :account
  belongs_to :host

  has_many :volumes

  def refresh
    unseen = volumes.pluck(:name)
    host.api.list_volumes(pool: path).each do |data|
      unseen -= [data[:name]]
      v = volumes.where(path: data[:name]).first_or_initialize(path: data[:name], name: data[:name], ephemeral: false)
      v.optical = !!(data[:name] =~ /\.iso$/)
      v.ephemeral = !v.ephemeral
      v.pool = self
      v.size = data[:size] / (1024 * 1024 * 1024) unless v.optical
      v.save!
    end
    volumes.where(name: unseen).delete_all
  end

  def full_name
    "#{name} in #{host.zone.full_name}"
  end

  def zone
    host.zone
  end

end
