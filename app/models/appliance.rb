# Copyright (c) 2016 Nathan Baum

class Appliance < ActiveRecord::Base

  belongs_to :template

end
