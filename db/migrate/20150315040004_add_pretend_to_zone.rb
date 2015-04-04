class AddPretendToZone < ActiveRecord::Migration
  def change
    add_column :zones, :pretend, :boolean, default: false
  end
end
