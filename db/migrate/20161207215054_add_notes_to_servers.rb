class AddNotesToServers < ActiveRecord::Migration
  def change
    add_column :servers, :notes, :text
  end
end
