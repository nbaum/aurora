class CreateServerEvents < ActiveRecord::Migration
  def change
    create_table :server_events do |t|
      t.references :server, index: true
      t.string :name
      t.json :data

      t.timestamps
    end
  end
end
