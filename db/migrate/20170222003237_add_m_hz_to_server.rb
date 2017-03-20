class AddMHzToServer < ActiveRecord::Migration
  def change
    add_column :servers, :mhz, :integer, default: 0
  end
end
