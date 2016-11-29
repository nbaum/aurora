# Copyright (c) 2016 Nathan Baum

class AddPathToStoragePools < ActiveRecord::Migration

  def change
    add_column :storage_pools, :path, :string
  end

end
