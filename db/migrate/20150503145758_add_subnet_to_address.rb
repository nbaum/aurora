# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class AddSubnetToAddress < ActiveRecord::Migration

  def change
    add_reference :addresses, :subnet, index: true
  end

end
