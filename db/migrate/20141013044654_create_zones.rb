# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

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
