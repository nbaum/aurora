# Copyright (c) 2016 Nathan Baum

class HostDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :zone

end
