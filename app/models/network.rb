class Network < ActiveRecord::Base
  belongs_to :account
  belongs_to :bundle
  belongs_to :zone
end
