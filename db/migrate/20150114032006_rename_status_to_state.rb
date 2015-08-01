# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class RenameStatusToState < ActiveRecord::Migration

  def change
    rename_column :servers, :status, :state
  end

end
