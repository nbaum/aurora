class AddIndexToNetwork < ActiveRecord::Migration
  def change
    add_column :networks, :index, :integer
  end
end
