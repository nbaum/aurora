class User < ActiveRecord::Base
  belongs_to :account
  has_secure_password validations: false

  validates :password, confirmation: true, length: 6..72, allow_nil: true
  validates :account_id, presence: true
  validates :email, format: /@.*\./, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def self.authenticate (email, password)
    if u = find_by(email: email)
      u.authenticate(password) && u
    end
  end

  def current_password
    nil
  end

end
