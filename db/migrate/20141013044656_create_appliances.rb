# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class CreateAppliances < ActiveRecord::Migration

  def change
    create_table :appliances do |t|
      t.string :name
      t.string :internal_class
      t.references :template, index: true

      t.timestamps
    end
  end

end
