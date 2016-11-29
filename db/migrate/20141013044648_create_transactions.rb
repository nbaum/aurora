# Copyright (c) 2016 Nathan Baum

class CreateTransactions < ActiveRecord::Migration

  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :description
      t.references :account, index: true

      t.timestamps
    end
  end

end
