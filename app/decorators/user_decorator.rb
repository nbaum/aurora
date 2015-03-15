class UserDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all

  links :account
end
