# Copyright (c) 2016 Nathan Baum

class CreateVolumes < ActiveRecord::Migration

  def change
    create_table :volumes do |t|
      t.string :name
      t.integer :size
      t.boolean :ephemeral
      t.boolean :optical
      t.references :server, index: true
      t.references :base, index: true
      t.references :account, index: true
      t.references :bundle, index: true
      t.references :storage_pool, index: true
      t.datetime :published_at

      t.timestamps
    end
  end

end
