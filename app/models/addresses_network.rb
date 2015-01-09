class AddressesNetwork < ActiveRecord::Base
  belongs_to :server
  belongs_to :network
end
