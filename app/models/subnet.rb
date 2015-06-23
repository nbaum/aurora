class Subnet < ActiveRecord::Base
  belongs_to :network

  has_many :addresses, dependent: :destroy

  KINDS = %w(IPv4 IPv6)

  validates :kind, inclusion: KINDS
  validates :prefix, numericality: { greater_than_or_equal_to: 0,
                                     less_than_or_equal_to: 32 },
                     if: -> s { s.kind == 'IPv4' }
  validates :prefix, numericality: { greater_than_or_equal_to: 0,
                                     less_than_or_equal_to: 128 },
                     if: -> s { s.kind == 'IPv6' }

  validate :valid_ipv4?, if: -> s { s.kind == 'IPv4' }
  validate :valid_ipv6?, if: -> s { s.kind == 'IPv6' }

  def valid_ipv4?
    %i(gateway first last).each do |name|
      unless self[name].ipv4?
        errors.add(name, "isn't a valid IPv4 address")
      end
    end
  end

  def valid_ipv6?
    %i(gateway first last).each do |name|
      unless self[name].ipv6?
        errors.add(name, "isn't a valid IPv4 address")
      end
    end
  end

  def ipv4?
    kind == 'IPv4'
  end

  def ipv6?
    kind == 'IPv6'
  end

  def name
    format("%s - %s", first, last)
  end

  def allocate_address (to)
    if !addresses.unassigned.empty?
      a = addresses.unassigned.first
      a.update! to
    elsif addresses.empty?
      addresses.create! to.merge(ip: first, network: network)
    elsif addresses.order("ip DESC").first.ip < last
      addresses.create! to.merge(ip: addresses.order("ip DESC").first.ip.succ, network: network)
    end
  end

  def netmask
    if ipv4?
      [(0xFFFFFFFF & ((1 << prefix.to_i) - 1))].pack("L").unpack("C4").join(".")
    else
      nil
    end
  end

end
