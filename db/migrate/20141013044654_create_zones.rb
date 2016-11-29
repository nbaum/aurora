# Copyright (c) 2016 Nathan Baum

class CreateZones < ActiveRecord::Migration

  def change
    create_table :zones do |t|
      t.string :name
      t.string :dns1
      t.string :dns2

      t.timestamps
    end
  end

end
