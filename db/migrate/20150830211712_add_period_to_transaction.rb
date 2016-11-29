# Copyright (c) 2016 Nathan Baum
class AddPeriodToTransaction < ActiveRecord::Migration

  def change
    add_column :transactions, :period, :string
  end

end
