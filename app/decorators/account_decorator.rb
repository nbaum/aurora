# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AccountDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :tariff, :zone

end
