class CreateEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.string :location, null: false
      t.date :event_date, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :required_volunteers, null: false
      t.string :status, null: false, default: "open"

      t.timestamps
    end
  end
end
