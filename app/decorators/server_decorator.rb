class ServerDecorator < Draper::Decorator
  delegate_all

  def link_if (item, name = item && item.name)
    item ? h.link_to(name, item) : h.content_tag(:span, "(None)", class: 'subdue')
  end

  def zone_link
    link_if(zone)
  end

  def appliance_link
    link_if(appliance)
  end

  def template_link
    link_if(template)
  end

  def bundle_link
    link_if(bundle)
  end

  def host_link
    link_if(host)
  end

  def status_icon
    h.content_tag(:i, '', class: 'fa fa-fw fa-stop')
  end

end
