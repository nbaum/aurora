# Copyright (c) 2016 Nathan Baum

class ApplianceDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
