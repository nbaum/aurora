class ApplianceDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all
end
