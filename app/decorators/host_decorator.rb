# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class HostDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :zone

end
