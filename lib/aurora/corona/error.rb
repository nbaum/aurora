class Aurora::Corona::Error < StandardError

  def initialize (message = nil, klass = nil, backtrace = [])
    super(message)
    @klass, @backtrace = klass, backtrace
  end

  def backtrace
    @backtrace
  end

end

