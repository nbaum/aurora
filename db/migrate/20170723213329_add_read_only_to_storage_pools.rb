class AddReadOnlyToStoragePools < ActiveRecord::Migration
  def change
    add_column :storage_pools, :read_only, :bool
  end
end
