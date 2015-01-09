class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.references :account, index: true
      t.boolean :administrator
      t.text :ssh_keys

      t.timestamps
    end
  end
end
