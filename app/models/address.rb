class Address < ActiveRecord::Base
  belongs_to :account
  belongs_to :server
  belongs_to :network
end
