# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class NetworkDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :account, :bundle, :zone

end
