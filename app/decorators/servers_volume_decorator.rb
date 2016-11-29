# Copyright (c) 2016 Nathan Baum

class ServersVolumeDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
