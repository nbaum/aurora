class StoragePool < ActiveRecord::Base
  belongs_to :account
  belongs_to :host
end
