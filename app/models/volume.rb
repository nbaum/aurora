class Volume < ActiveRecord::Base
  belongs_to :server
  belongs_to :base
  belongs_to :account
  belongs_to :bundle
  belongs_to :storage_pool
end
