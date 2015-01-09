class ServersVolume < ActiveRecord::Base
  belongs_to :server
  belongs_to :volume
end
