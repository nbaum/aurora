class Bundle < ActiveRecord::Base
  belongs_to :account
  has_many :servers
  has_many :volumes
  has_many :networks
end
