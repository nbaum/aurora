# Copyright (c) 2016 Nathan Baum

class AddEnabledToHost < ActiveRecord::Migration

  def change
    add_column :hosts, :enabled, :boolean, default: true
  end

end
