# Copyright (c) 2016 Nathan Baum
class AddClosedAtToTransaction < ActiveRecord::Migration

  def change
    add_column :transactions, :closed_at, :timestamp
  end

end
