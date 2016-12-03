# Copyright (c) 2016 Nathan Baum

using Aurora::Refinements::NumberFormatting

class VolumeDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :server, :base, :account, :bundle, :pool, :server

  def size_format
    h.content_tag(:abbr, (size * 1_000_000_000).decimal_si, title: size.delimited + " gigabytes")
  end

end
