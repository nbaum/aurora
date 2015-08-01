# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class Transaction < ActiveRecord::Base

  belongs_to :account

end
