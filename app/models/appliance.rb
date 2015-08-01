# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class Appliance < ActiveRecord::Base

  belongs_to :template

end
