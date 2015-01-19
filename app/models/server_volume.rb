class ServerVolume < ActiveRecord::Base
  self.table_name = 'servers_volumes'

  belongs_to :server
  belongs_to :volume
end
