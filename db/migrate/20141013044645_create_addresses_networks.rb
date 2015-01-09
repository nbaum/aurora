class CreateAddressesNetworks < ActiveRecord::Migration
  def change
    create_table :addresses_networks do |t|
      t.string :attachment
      t.references :server, index: true
      t.references :network, index: true

      t.timestamps
    end
  end
end
