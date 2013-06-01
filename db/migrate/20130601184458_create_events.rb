class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :json
      t.integer :event_id
      t.boolean :livemode
      t.string :event_type

      t.timestamps
    end
  end
end
