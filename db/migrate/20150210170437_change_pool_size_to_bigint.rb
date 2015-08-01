# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class ChangePoolSizeToBigint < ActiveRecord::Migration

  def change
    change_column :storage_pools, :size, :bigint
  end

end
