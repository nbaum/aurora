class CreateHosts < ActiveRecord::Migration
  def change
    create_table :hosts do |t|
      t.string :name
      t.integer :cores
      t.integer :memory
      t.integer :storage
      t.string :url
      t.inet :address
      t.boolean :compute
      t.boolean :storage
      t.references :zone, index: true

      t.timestamps
    end
  end
end
