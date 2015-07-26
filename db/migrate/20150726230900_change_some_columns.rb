class ChangeSomeColumns < ActiveRecord::Migration
  def change
    remove_column :jobs, :state, :jsonb
    remove_column :jobs, :args, :jsonb
    add_column :jobs, :state, :json, default: {}
    add_column :jobs, :args, :json, default: {}
  end
end
