class AddTagsToServers < ActiveRecord::Migration
  def change
    add_column :servers, :tags, :string, array: true, default: []
  end
end
