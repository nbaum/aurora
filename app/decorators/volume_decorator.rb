class VolumeDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all

  links :server, :base, :account, :bundle, :pool, :server

end
