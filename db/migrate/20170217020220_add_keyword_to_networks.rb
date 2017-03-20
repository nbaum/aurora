class AddKeywordToNetworks < ActiveRecord::Migration
  def change
    add_column :networks, :keyword, :string
  end
end
