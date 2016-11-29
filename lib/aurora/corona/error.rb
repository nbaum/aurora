# Copyright (c) 2016 Nathan Baum

class Aurora::Corona::Error < StandardError

  def initialize (message = nil, klass = nil, backtrace = [])
    super(message)
    @klass = klass
    @backtrace = backtrace
  end

  attr_reader :backtrace

end
