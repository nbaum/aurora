# Copyright (c) 2016 Nathan Baum

class Session < ActiveRecord::Base

  belongs_to :user

  attr_accessor :email, :password

  validate :its_an_old_code_but_it_checks_out, if: :new_record?

  def its_an_old_code_but_it_checks_out
    return if user
    if u = User.authenticate(email, password)
      self.user = u
    else
      errors[:base] << "Email or password not accepted"
    end
  end

  def started_at
    created_at
  end

  def ended_at
    updated_at != created_at ? updated_at : nil
  end

end
