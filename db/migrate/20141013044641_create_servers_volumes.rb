# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class CreateServersVolumes < ActiveRecord::Migration

  def change
    create_table :servers_volumes do |t|
      t.string :attachment
      t.references :server, index: true
      t.references :volume, index: true

      t.timestamps
    end
  end

end
