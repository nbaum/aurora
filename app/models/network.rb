# Copyright (c) 2016 Nathan Baum

class Network < ActiveRecord::Base

  belongs_to :account
  belongs_to :bundle
  belongs_to :zone

  has_many :addresses, through: :subnets, dependent: :destroy
  has_many :subnets, dependent: :destroy

  after_initialize if: :new_record? do
    self.index ||= Network.maximum(:index) + 1
  end

  def netname
    name.downcase.tr(" ", "-").tr("^a-z0-9-", "")
  end

  def portname
    "ens#{index + 3}"
  end

  def allocate_address (kind, to)
    subnets.where(kind: kind).each do |subnet|
      if a = subnet.allocate_address(to)
        return a
      end
    end
  end

  def free_address_count
    subnets.map(&:free_address_count).sum
  end

end
