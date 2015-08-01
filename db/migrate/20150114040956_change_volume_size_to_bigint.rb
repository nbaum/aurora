# encoding: utf-8
# Copyright (c) 2015 Orbital Informatics Ltd

class ChangeVolumeSizeToBigint < ActiveRecord::Migration

  def change
    change_column :volumes, :size, :bigint
  end

end
