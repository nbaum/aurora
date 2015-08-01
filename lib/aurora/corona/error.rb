# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class Aurora::Corona::Error < StandardError

  def initialize (message = nil, klass = nil, backtrace = [])
    super(message)
    @klass = klass
    @backtrace = backtrace
  end

  attr_reader :backtrace

end
