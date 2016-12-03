class AddTargetToJob < ActiveRecord::Migration
  def change
    add_column :jobs, :target_id, :integer
    add_column :jobs, :target_type, :string
  end
end
