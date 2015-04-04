class Aurora::Corona::Fake < BasicObject

  def initialize (reliability, url, args)
    @reliability = reliability
    @url = url
    @args = args
  end

  def realize (base: nil, size: nil)
    maybe_fail
  end

  def start (config: nil)
    maybe_fail
  end

  def stop ()
    maybe_fail
  end

  def pause ()
    maybe_fail
  end

  def unpause ()
    maybe_fail
  end

  def suspend (tag: nil)
    maybe_fail
  end

  def resume (tag: nil, config: nil)
    maybe_fail
  end

  def delete ()
    maybe_fail
  end

  private

  def maybe_fail (value = true, &block)
    if ::Kernel.rand(@reliability) > 0
      block ? block.() : value
    else
      ::Kernel.raise ::Aurora::Corona::Error.new("Simulated failure", nil, ::Kernel.caller)
    end
  end

end
