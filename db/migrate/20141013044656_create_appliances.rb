# Copyright (c) 2016 Nathan Baum

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
