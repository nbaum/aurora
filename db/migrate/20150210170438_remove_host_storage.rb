# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class RemoveHostStorage < ActiveRecord::Migration

  def change
    remove_column :hosts, :storage
  end

end
