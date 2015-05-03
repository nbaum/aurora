class CreateSubnets < ActiveRecord::Migration
  def change
    create_table :subnets do |t|
      t.string :kind
      t.string :prefix
      t.inet :gateway
      t.inet :first
      t.inet :last
      t.references :network, index: true

      t.timestamps
    end
  end
end
