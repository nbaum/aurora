# Copyright (c) 2016 Nathan Baum

class AddPathToVolumes < ActiveRecord::Migration

  def change
    add_column :volumes, :path, :string
  end

end
