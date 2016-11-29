# Copyright (c) 2016 Nathan Baum

class AddressesNetworkDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
