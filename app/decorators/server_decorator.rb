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

  def iso_link
    link_if(iso)
  end

  def root_link
    link_if(root)
  end

  def state_icon
    case state
    when 'stopped'
      h.content_tag(:i, '', class: 'fa fa-fw fa-stop')
    when 'running'
      h.content_tag(:i, '', class: 'fa fa-fw fa-play')
    when 'paused'
      h.content_tag(:i, '', class: 'fa fa-fw fa-pause')
    else
      h.content_tag(:i, '', class: 'fa fa-fw fa-question')
    end
  end

end
