# Copyright (c) 2016 Nathan Baum

class AccountDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :tariff, :zone

end
