# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

module Lockable

  def lock_for (term)
    self.class.lock(term).find(id)
  end

  def lock
    lock_for("for update")
  end

  def lock_shared
    lock_for("for share")
  end

end
