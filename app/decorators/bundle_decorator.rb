class BundleDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all

  links :account
end
