# Copyright (c) 2016 Nathan Baum

class UserDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :account

end
