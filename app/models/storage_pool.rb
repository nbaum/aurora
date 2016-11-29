# Copyright (c) 2016 Nathan Baum

class StoragePool < ActiveRecord::Base

  belongs_to :account
  belongs_to :host

  has_many :volumes

  def refresh
    host.api.list_volumes(pool: path).each do |data|
      v = volumes.where(path: data[:name]).first_or_initialize(path: data[:name], name: data[:name], ephemeral: false)
      v.optical = !!(data[:name] =~ /\.iso$/)
      v.ephemeral = !v.ephemeral
      v.pool = self
      v.size = data[:size]
      v.save!
    end
  end

end
