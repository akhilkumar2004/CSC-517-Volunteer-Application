class Volunteer < ApplicationRecord
	has_secure_password

	has_many :volunteer_assignments, dependent: :destroy
	has_many :events, through: :volunteer_assignments

	validates :username, presence: true, uniqueness: true
	validates :full_name, presence: true
	validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

	def total_hours
		volunteer_assignments.completed.sum(:hours_worked).to_f
	end
end
