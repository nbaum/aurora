class AddSubnetToAddress < ActiveRecord::Migration
  def change
    add_reference :addresses, :subnet, index: true
  end
end
