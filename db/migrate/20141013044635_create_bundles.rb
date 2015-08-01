# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class CreateBundles < ActiveRecord::Migration

  def change
    create_table :bundles do |t|
      t.string :name
      t.datetime :published_at
      t.references :account, index: true

      t.timestamps
    end
  end

end
