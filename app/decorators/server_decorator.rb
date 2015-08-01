# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

using Aurora::Refinements::NumberFormatting

class ServerDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :zone, :appliance, :template, :bundle, :host, :iso, :root, :account

  def memory_format
    h.content_tag(:abbr, memory.*(1_048_576).binary_si,
                  title: memory.*(1_048_576).delimited + " bytes")
  end

  def storage_format
    h.content_tag(:abbr, storage.*(1_000_000_000).decimal_si,
                  title: storage.*(1_000_000_000).delimited + " bytes")
  end

  def state_icon
    case state
    when "stopped"
      h.content_tag(:i, "", class: "fa fa-fw fa-stop", title: state)
    when "running"
      h.content_tag(:i, "", class: "fa fa-fw fa-play", title: state)
    when "paused"
      h.content_tag(:i, "", class: "fa fa-fw fa-pause", title: state)
    else
      h.content_tag(:i, "", class: "fa fa-fw fa-question", title: state)
    end
  end

  def spec
    "#{cores} vCPU, #{memory} MiB, #{storage} GB"
  end

end
