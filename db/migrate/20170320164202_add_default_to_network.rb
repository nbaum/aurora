class AddDefaultToNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :default, :boolean, default: false
  end
end
