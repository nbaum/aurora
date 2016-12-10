# Copyright (c) 2016 Nathan Baum

class VolumeDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :server, :base, :account, :bundle, :pool, :server

  def size_format
    h.content_tag(:abbr, (size * 1_000_000_000).decimal_si, title: size.delimited + " gigabytes")
  end

  def used_format
    h.content_tag(:abbr, used.decimal_si)
  end

end
