class Array

  def or_none (text = "(None)")
    [[text, nil], *self]
  end

end
