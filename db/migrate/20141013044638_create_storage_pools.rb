class CreateStoragePools < ActiveRecord::Migration
  def change
    create_table :storage_pools do |t|
      t.string :name
      t.integer :size
      t.references :account, index: true
      t.references :host, index: true

      t.timestamps
    end
  end
end
