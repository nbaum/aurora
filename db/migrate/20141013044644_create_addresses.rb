class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.inet :ip
      t.references :account, index: true
      t.references :server, index: true
      t.references :network, index: true

      t.timestamps
    end
  end
end
