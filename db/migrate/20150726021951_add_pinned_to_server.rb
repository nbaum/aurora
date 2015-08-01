# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddPinnedToServer < ActiveRecord::Migration

  def change
    add_column :servers, :pinned, :boolean, default: false
  end

end
