# Copyright (c) 2016 Nathan Baum

class NetworkDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :account, :bundle, :zone

end
