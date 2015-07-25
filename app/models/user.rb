class User < ActiveRecord::Base
  has_secure_password validations: false

  belongs_to :account

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

  def jobs
    @@jobs ||= {}
    @@jobs[self.id] ||= []
  end

  def job (title, *args, &block)
    job = Job.spawn(title, *args, &block)
    jobs.unshift job
    job
  end

end
