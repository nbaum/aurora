class Network < ActiveRecord::Base
  belongs_to :account
  belongs_to :bundle
  belongs_to :zone

  has_many :addresses, dependent: :destroy
  has_many :subnets, dependent: :destroy

  before_save do
    if first && last
      (first..last).each do |addr|
        addresses.where(ip: addr).first_or_create!
      end
    end
  end

  after_save do
    if subnets.empty?
      s = subnets.create! kind: 'ipv4', prefix: prefix, first: first.to_s, last: last.to_s
      addresses.each do |addr|
        addr.update_attributes! subnet: s, network: nil
      end
    end
  end

  def allocate_address (kind, to)
    subnets.where(kind: kind).each do |subnet|
      if a = subnet.allocate_address(to)
        return a
      end
    end
  end

end
