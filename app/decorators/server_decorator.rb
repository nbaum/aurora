class ServerDecorator < Draper::Decorator
  include Draper::Linker
  delegate_all

  links :zone, :appliance, :template, :bundle, :host, :iso, :root, :base

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
