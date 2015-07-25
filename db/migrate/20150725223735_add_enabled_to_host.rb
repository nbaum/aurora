class AddEnabledToHost < ActiveRecord::Migration
  def change
    add_column :hosts, :enabled, :boolean, default: true
  end
end
