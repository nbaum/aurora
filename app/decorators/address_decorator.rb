# Copyright (c) 2016 Nathan Baum

class AddressDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :server, :account

end
