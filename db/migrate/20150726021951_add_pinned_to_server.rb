# Copyright (c) 2016 Nathan Baum

class AddPinnedToServer < ActiveRecord::Migration

  def change
    add_column :servers, :pinned, :boolean, default: false
  end

end
