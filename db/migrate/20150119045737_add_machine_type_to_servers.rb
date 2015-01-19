class AddMachineTypeToServers < ActiveRecord::Migration
  def change
    add_column :servers, :machine_type, :string
  end
end
