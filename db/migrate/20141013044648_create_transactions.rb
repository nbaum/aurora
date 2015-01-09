class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.decimal :amount
      t.string :description
      t.references :account, index: true

      t.timestamps
    end
  end
end
