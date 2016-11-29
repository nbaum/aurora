# Copyright (c) 2016 Nathan Baum
class RenameAmountToRate < ActiveRecord::Migration

  def change
    rename_column :transactions, :amount, :rate
  end

end
