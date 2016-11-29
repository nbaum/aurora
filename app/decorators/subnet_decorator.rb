# Copyright (c) 2016 Nathan Baum

class SubnetDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :network

end
