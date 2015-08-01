# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class Account < ActiveRecord::Base

  belongs_to :tariff
  belongs_to :zone
  has_many :servers

end
