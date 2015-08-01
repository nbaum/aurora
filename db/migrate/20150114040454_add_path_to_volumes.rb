# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddPathToVolumes < ActiveRecord::Migration

  def change
    add_column :volumes, :path, :string
  end

end
