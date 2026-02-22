class Event < ApplicationRecord
	has_many :volunteer_assignments, dependent: :destroy
	has_many :volunteers, through: :volunteer_assignments

	enum :status, { open: "open", full: "full", completed: "completed" }, default: :open

	validates :title, :description, :location, :event_date, :start_time, :end_time, :status, presence: true
	validates :required_volunteers, presence: true, numericality: { greater_than: 0 }
	validate :start_before_end

	def assigned_count
		volunteer_assignments.where(status: %w[approved completed]).count
	end

	def available_slots
		[required_volunteers - assigned_count, 0].max
	end

	def can_accept_volunteers?
		open? && available_slots.positive?
	end

	def refresh_status!
		return if completed?

		next_status = assigned_count >= required_volunteers ? "full" : "open"
		update_column(:status, next_status) if status != next_status
	end

	private

	def start_before_end
		return if start_time.blank? || end_time.blank?

		errors.add(:start_time, "must be before end time") if start_time >= end_time
	end
end
