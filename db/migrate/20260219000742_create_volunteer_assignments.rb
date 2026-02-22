class CreateVolunteerAssignments < ActiveRecord::Migration[8.0]
  def change
    create_table :volunteer_assignments do |t|
      t.references :volunteer, null: false, foreign_key: true
      t.references :event, null: false, foreign_key: true
      t.string :status, null: false, default: "pending"
      t.decimal :hours_worked, precision: 6, scale: 2
      t.date :date_logged

      t.timestamps
    end
  end
end
