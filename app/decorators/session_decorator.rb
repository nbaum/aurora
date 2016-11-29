# Copyright (c) 2016 Nathan Baum

class SessionDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :user

end
