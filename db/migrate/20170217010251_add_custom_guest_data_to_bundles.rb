class AddCustomGuestDataToBundles < ActiveRecord::Migration
  def change
    add_column :bundles, :custom_guest_data, :json, default: {}
  end
end
