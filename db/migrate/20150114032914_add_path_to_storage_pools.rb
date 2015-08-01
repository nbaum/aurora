# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddPathToStoragePools < ActiveRecord::Migration

  def change
    add_column :storage_pools, :path, :string
  end

end
