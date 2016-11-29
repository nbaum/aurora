# Copyright (c) 2016 Nathan Baum

class TariffDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
