class AddReadonlyToStoragePools < ActiveRecord::Migration
  def change
    add_column :storage_pools, :readonly, :bool
  end
end
