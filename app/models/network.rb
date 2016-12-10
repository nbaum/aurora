# Copyright (c) 2016 Nathan Baum

class Network < ActiveRecord::Base

  belongs_to :account
  belongs_to :bundle
  belongs_to :zone

  has_many :addresses, dependent: :destroy
  has_many :subnets, dependent: :destroy

  after_initialize do
    self.index ||= 0
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
