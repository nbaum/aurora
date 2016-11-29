# Copyright (c) 2016 Nathan Baum

class CreateServers < ActiveRecord::Migration

  def change
    create_table :servers do |t|
      t.string :name
      t.integer :cores
      t.integer :memory
      t.integer :storage
      t.string :password
      t.string :status
      t.integer :affinity_group
      t.json :appliance_data
      t.references :template, index: true
      t.references :host, index: true
      t.references :account, index: true
      t.references :zone, index: true
      t.references :appliance, index: true
      t.references :bundle, index: true
      t.datetime :published_at
      t.references :base, index: true
      t.references :current, index: true

      t.timestamps
    end
  end

end
