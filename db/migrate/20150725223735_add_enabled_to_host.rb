# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddEnabledToHost < ActiveRecord::Migration

  def change
    add_column :hosts, :enabled, :boolean, default: true
  end

end
