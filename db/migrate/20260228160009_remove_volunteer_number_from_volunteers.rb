class RemoveVolunteerNumberFromVolunteers < ActiveRecord::Migration[8.0]
  def change
    remove_column :volunteers, :volunteer_number, :integer
  end
end
