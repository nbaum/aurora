class CreateTariffs < ActiveRecord::Migration
  def change
    create_table :tariffs do |t|
      t.boolean :default
      t.string :name
      t.decimal :core
      t.decimal :memory
      t.decimal :storage
      t.decimal :address

      t.timestamps
    end
  end
end
