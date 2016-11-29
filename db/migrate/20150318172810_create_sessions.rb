# Copyright (c) 2016 Nathan Baum

class CreateSessions < ActiveRecord::Migration

  def change
    create_table :sessions do |t|
      t.references :user

      t.timestamps
    end
  end

end
