# Copyright (c) 2016 Nathan Baum

class AddReliabilityToZone < ActiveRecord::Migration

  def change
    add_column :zones, :reliability, :integer, default: 0
  end

end
