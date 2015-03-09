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

  def base_link
    link_if(base)
  end

  def state_icon
    case state
    when 'stopped'
      h.content_tag(:i, '', class: 'fa fa-fw fa-stop', title: state)
    when 'running'
      h.content_tag(:i, '', class: 'fa fa-fw fa-play', title: state)
    when 'paused'
      h.content_tag(:i, '', class: 'fa fa-fw fa-pause', title: state)
    else
      h.content_tag(:i, '', class: 'fa fa-fw fa-question', title: state)
    end
  end

end
