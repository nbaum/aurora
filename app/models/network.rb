class Network < ActiveRecord::Base
  belongs_to :account
  belongs_to :bundle
  belongs_to :zone

  has_many :addresses

  before_save do
    if first && last
      (first..last).each do |addr|
        addresses.where(ip: addr).first_or_create!
      end
    end
  end

  def netmask
    [(0xFFFFFFFF & ((1 << prefix) - 1))].pack("L").unpack("C4").join(".")
  end

end
