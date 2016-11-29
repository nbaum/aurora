# Copyright (c) 2016 Nathan Baum

class Transaction < ActiveRecord::Base

  belongs_to :account

end
