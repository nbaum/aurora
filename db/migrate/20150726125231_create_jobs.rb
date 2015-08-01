# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class CreateJobs < ActiveRecord::Migration

  def change
    create_table :jobs do |t|
      t.string :type
      t.string :status

      t.jsonb :args, default: {}
      t.jsonb :state, default: {}

      t.references :owner, index: true
      t.references :server, index: true

      t.timestamp :started_at
      t.timestamp :finished_at
      t.timestamps
    end
  end

end
