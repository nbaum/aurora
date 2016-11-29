# Copyright (c) 2016 Nathan Baum

class ChangePoolSizeToBigint < ActiveRecord::Migration

  def change
    change_column :storage_pools, :size, :bigint
  end

end
