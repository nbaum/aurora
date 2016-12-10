class AddLdapDataToAccounts < ActiveRecord::Migration
  def change
    add_column :accounts, :ldap_host, :string
    add_column :accounts, :ldap_pattern, :string
  end
end
