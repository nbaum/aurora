# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class Address < ActiveRecord::Base

  belongs_to :account
  belongs_to :server
  belongs_to :network
  belongs_to :subnet

  scope :unassigned, -> { where(account: nil, server: nil) }

end
