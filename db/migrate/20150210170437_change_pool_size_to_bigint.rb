class ChangePoolSizeToBigint < ActiveRecord::Migration
  def change
    change_column :storage_pools, :size, :bigint
  end
end
