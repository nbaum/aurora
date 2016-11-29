# Copyright (c) 2016 Nathan Baum

class AddBootOrderToServers < ActiveRecord::Migration

  def change
    add_column :servers, :boot_order, :string
  end

end
