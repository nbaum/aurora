class AddDomainsToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :domains, :string, array: true, default: []
  end
end
