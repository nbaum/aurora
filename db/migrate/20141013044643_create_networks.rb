# Copyright (c) 2016 Nathan Baum

class CreateNetworks < ActiveRecord::Migration

  def change
    create_table :networks do |t|
      t.string :name
      t.string :bridge
      t.string :gateway
      t.integer :prefix
      t.inet :first
      t.inet :last
      t.references :account, index: true
      t.references :bundle, index: true
      t.references :zone, index: true

      t.timestamps
    end
  end

end
