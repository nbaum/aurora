class ChangeVolumeSizeToBigint < ActiveRecord::Migration
  def change
    change_column :volumes, :size, :bigint
  end
end
