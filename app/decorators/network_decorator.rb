class NetworkDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all

  links :account, :bundle, :zone

end
