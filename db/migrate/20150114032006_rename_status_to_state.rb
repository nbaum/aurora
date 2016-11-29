# Copyright (c) 2016 Nathan Baum

class RenameStatusToState < ActiveRecord::Migration

  def change
    rename_column :servers, :status, :state
  end

end
