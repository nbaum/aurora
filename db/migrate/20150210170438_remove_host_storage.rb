class RemoveHostStorage < ActiveRecord::Migration
  def change
    remove_column :hosts, :storage
  end
end
