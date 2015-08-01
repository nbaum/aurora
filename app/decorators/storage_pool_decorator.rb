# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class StoragePoolDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :account, :host

end
