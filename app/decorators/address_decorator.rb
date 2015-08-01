# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddressDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :server, :account

end
