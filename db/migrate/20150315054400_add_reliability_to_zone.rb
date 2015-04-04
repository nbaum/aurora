class AddReliabilityToZone < ActiveRecord::Migration
  def change
    add_column :zones, :reliability, :integer, default: 0
  end
end
