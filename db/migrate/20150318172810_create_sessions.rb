# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class CreateSessions < ActiveRecord::Migration

  def change
    create_table :sessions do |t|
      t.references :user

      t.timestamps
    end
  end

end
