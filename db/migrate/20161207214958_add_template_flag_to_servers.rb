class AddTemplateFlagToServers < ActiveRecord::Migration
  def change
    add_column :servers, :is_template, :boolean, default: false
  end
end
