class CreateServersVolumes < ActiveRecord::Migration
  def change
    create_table :servers_volumes do |t|
      t.string :attachment
      t.references :server, index: true
      t.references :volume, index: true

      t.timestamps
    end
  end
end
