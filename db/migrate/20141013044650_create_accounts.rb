# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

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
