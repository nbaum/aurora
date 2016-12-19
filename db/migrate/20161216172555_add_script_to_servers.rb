class AddScriptToServers < ActiveRecord::Migration
  def change
    add_column :servers, :script, :text
  end
end
