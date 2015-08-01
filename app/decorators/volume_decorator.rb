# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

using Aurora::Refinements::NumberFormatting

class VolumeDecorator < Draper::Decorator

  include Draper::Linker
  delegate_all

  links :server, :base, :account, :bundle, :pool, :server

  def size_format
    h.content_tag(:abbr, size.decimal_si, title: size.delimited + " bytes")
  end

end
