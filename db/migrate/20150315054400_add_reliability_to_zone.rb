# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddReliabilityToZone < ActiveRecord::Migration

  def change
    add_column :zones, :reliability, :integer, default: 0
  end

end
