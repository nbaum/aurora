# Copyright (c) 2016 Nathan Baum

class Array

  def or_none (text = "(None)")
    [[text, nil], *self]
  end

end
