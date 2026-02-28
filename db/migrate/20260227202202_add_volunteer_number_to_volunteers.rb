class AddVolunteerNumberToVolunteers < ActiveRecord::Migration[8.0]
  def change
    add_column :volunteers, :volunteer_number, :integer
  end
end
