require 'aurora/corona'

class Zone < ActiveRecord::Base

  has_many :hosts

  def dns
    [dns1, dns2]
  end

  def pick_host (server)
    hosts.sample
  end

  def api (url, args = {})
    Aurora::Corona.new(url, args)
  end

end
