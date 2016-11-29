# Copyright (c) 2016 Nathan Baum
class AddKindToTransaction < ActiveRecord::Migration

  def change
    add_column :transactions, :kind, :string
  end

end
