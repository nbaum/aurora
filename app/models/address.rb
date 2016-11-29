# Copyright (c) 2016 Nathan Baum

class Address < ActiveRecord::Base

  belongs_to :account
  belongs_to :server
  belongs_to :network
  belongs_to :subnet

  scope :unassigned, -> { where(account: nil, server: nil) }

end
