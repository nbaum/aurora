# Copyright (c) 2016 Nathan Baum

class BundleDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :account

end
