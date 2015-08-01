# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

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
