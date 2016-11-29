# Copyright (c) 2016 Nathan Baum

class Account < ActiveRecord::Base

  belongs_to :tariff
  belongs_to :zone
  has_many :servers

end
