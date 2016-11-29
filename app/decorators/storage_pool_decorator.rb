# Copyright (c) 2016 Nathan Baum

class StoragePoolDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :account, :host

end
