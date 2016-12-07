# Copyright (c) 2016 Nathan Baum

using Aurora::Refinements::NumberFormatting

class ServerDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :zone, :appliance, :template, :bundle, :host, :iso, :root, :account

  def charge_format
    "£#{charge * 60 * 60 * 24 * '30.436875'.to_d} / month".html_safe
  end

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
      h.content_tag(:span, "Stopped", class: "server-state stopped")
    when "running"
      h.content_tag(:span, "Running", class: "server-state running")
    when "paused"
      h.content_tag(:span, "Paused", class: "server-state paused")
    else
      h.content_tag(:span, "Unknown", class: "server-state unknown")
    end
  end

  def spec
    "#{cores} vCPU, #{memory} MiB, #{storage} GB"
  end

end
