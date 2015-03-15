class Aurora::Corona::Fake < BasicObject

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

  def maybe_fail
    ::Kernel.rand(2) > 0 ? true : ::Kernel.raise(::Aurora::Corona::Error, "Simulated failure")
  end

end
