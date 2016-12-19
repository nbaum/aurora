class AddStepsToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :steps, :text
  end
end
