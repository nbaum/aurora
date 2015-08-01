# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class Array

  def or_none (text = "(None)")
    [[text, nil], *self]
  end

end
