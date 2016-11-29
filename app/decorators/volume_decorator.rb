# Copyright (c) 2016 Nathan Baum

using Aurora::Refinements::NumberFormatting

class VolumeDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :server, :base, :account, :bundle, :pool, :server

  def size_format
    h.content_tag(:abbr, size.decimal_si, title: size.delimited + " bytes")
  end

end
