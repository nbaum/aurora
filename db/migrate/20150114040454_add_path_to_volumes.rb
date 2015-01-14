class AddPathToVolumes < ActiveRecord::Migration
  def change
    add_column :volumes, :path, :string
  end
end
