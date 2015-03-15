class AccountDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all

  links :tariff, :zone
end
