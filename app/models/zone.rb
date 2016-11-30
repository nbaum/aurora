# Copyright (c) 2016 Nathan Baum

require "aurora/corona"

class Zone < ActiveRecord::Base

  has_many :hosts
  has_many :pools, through: :hosts, class_name: "StoragePool"

  has_many :networks

  def dns
    [dns1, dns2]
  end

  def pick_compute_host (exclude: nil)
    candidates = hosts.compute
    candidates = candidates.where.not(id: exclude.id) if exclude
    candidates.sample
  end

  def api (url, args = {})
    if pretend
      Aurora::Corona::Mock.new(url, args)
    else
      Aurora::Corona.new(url, args)
    end
  end

  def full_name
    name
  end

end
