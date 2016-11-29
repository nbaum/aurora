# Copyright (c) 2016 Nathan Baum

class CreateAccounts < ActiveRecord::Migration

  def change
    create_table :accounts do |t|
      t.string :name
      t.decimal :balance
      t.references :tariff, index: true
      t.references :zone, index: true

      t.timestamps
    end
  end

end
