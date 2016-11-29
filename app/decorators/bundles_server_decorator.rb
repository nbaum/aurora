# Copyright (c) 2016 Nathan Baum

class BundlesServerDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

end
