class AddNetworksToServers < ActiveRecord::Migration
  def change
    add_reference :servers, :networks, index: true, array: true, default: []
    reversible do |dir|
      dir.up do
        Server.update_all networks_id: Network.all.map(&:id)
      end
    end
  end
end
