class AddIndexToVolunteersVolunteerNumber < ActiveRecord::Migration[8.0]
  def change
    add_column :volunteers, :volunteer_number, :integer
    add_index :volunteers, :volunteer_number, unique: true
  end
end