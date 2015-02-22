class BundleDecorator < Draper::Decorator
  delegate_all

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end

  def link_if (item, name = item && item.name)
    item ? h.link_to(name, item) : h.content_tag(:span, "(None)", class: 'subdue')
  end

  def account_link
    link_if(account)
  end

end
