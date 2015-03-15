class HostDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all

  links :zone
end
