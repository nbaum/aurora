require 'aurora/corona'

class Zone < ActiveRecord::Base

  has_many :hosts
  has_many :pools, through: :hosts, class_name: 'StoragePool'

  has_many :networks

  def dns
    [dns1, dns2]
  end

  def pick_host (server)
    hosts.sample
  end

  class PretendApi < BasicObject
    
    def realize (args)
      true
    end
    
  end

  def api (url, args = {})
    if pretend
      Aurora::Corona::Fake.new(reliability, url, args)
    else
      Aurora::Corona.new(url, args)
    end
  end

end
