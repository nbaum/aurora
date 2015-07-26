class AddPinnedToServer < ActiveRecord::Migration
  def change
    add_column :servers, :pinned, :boolean, default: false
  end
end
