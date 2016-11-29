# Copyright (c) 2016 Nathan Baum

class RemoveHostStorage < ActiveRecord::Migration

  def change
    remove_column :hosts, :storage
  end

end
