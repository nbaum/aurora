# Copyright (c) 2016 Nathan Baum

class Network < ActiveRecord::Base

  belongs_to :account
  belongs_to :bundle
  belongs_to :zone

  has_many :addresses, dependent: :destroy
  has_many :subnets, dependent: :destroy

  def allocate_address (kind, to)
    subnets.where(kind: kind).each do |subnet|
      if a = subnet.allocate_address(to)
        return a
      end
    end
  end

end
