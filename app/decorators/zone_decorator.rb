# Copyright (c) 2016 Nathan Baum

class ZoneDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
