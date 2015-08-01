# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddMachineTypeToServers < ActiveRecord::Migration

  def change
    add_column :servers, :machine_type, :string
  end

end
