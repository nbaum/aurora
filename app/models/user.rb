class User < ActiveRecord::Base
  belongs_to :account
  has_secure_password

  def self.authenticate (email, password)
    if u = find_by(email: email)
      u.authenticate(password) && u
    end
  end

  def current_password
    nil
  end

end
