# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddPretendToZone < ActiveRecord::Migration

  def change
    add_column :zones, :pretend, :boolean, default: false
  end

end
