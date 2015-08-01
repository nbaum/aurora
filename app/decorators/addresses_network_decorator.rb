# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddressesNetworkDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
