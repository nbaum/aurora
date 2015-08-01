# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddBootOrderToServers < ActiveRecord::Migration

  def change
    add_column :servers, :boot_order, :string
  end

end
