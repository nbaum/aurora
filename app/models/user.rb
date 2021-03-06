# Copyright (c) 2016 Nathan Baum

class User < ActiveRecord::Base

  has_secure_password validations: false

  belongs_to :account

  has_many :jobs, foreign_key: "owner_id"

  validates :password, confirmation: true, length: 6..72, allow_nil: true
  validates :account_id, presence: true
  validates :email, format: /@.*\./, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def self.authenticate (email, password)
    username, domain = email.split("@")
    if (a = Account.where("? = ANY(domains)", domain).first) && a.authenticate(email, password)
      where(email: email).first_or_create!(account: a, name: email)
    end
  end

  def current_password
    nil
  end

  def job (type, **args)
    keys = {}
    keys[:target] = args.delete(:server)
    keys[:target] ||= args.delete(:bundle)
    Job.create!(status: "pending", owner: self, type: "jobs/#{type}".camelize, args: args, **keys)
  end

end
