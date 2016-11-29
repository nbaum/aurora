# Copyright (c) 2016 Nathan Baum

class AddPretendToZone < ActiveRecord::Migration

  def change
    add_column :zones, :pretend, :boolean, default: false
  end

end
