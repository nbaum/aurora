class AddCustomGuestDataToServers < ActiveRecord::Migration
  def change
    add_column :servers, :custom_guest_data, :json, default: {}
  end
end
