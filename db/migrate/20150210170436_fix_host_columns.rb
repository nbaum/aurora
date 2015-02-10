class FixHostColumns < ActiveRecord::Migration
  def change
    rename_column :hosts, :storage, :has_storage
    rename_column :hosts, :compute, :has_compute
    add_column :hosts, :storage, :bigint
  end
end
