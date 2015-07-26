class User < ActiveRecord::Base
  has_secure_password validations: false

  belongs_to :account

  has_many :jobs, foreign_key: 'owner_id'

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

  def job (type, **args)
    keys = {}
    keys[:server] = args.delete(:server)
    job = Job.create!(status: "pending", owner: self, type: "jobs/#{type}".camelize, args: args, **keys)
    job.schedule
    job.wait
    job
  end

end
