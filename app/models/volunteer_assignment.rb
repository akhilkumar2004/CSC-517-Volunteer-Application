class VolunteerAssignment < ApplicationRecord
  belongs_to :volunteer
  belongs_to :event

  enum :status, {
    pending: "pending",
    approved: "approved",
    completed: "completed",
    cancelled: "cancelled",
    rejected: "rejected"
  }, default: :pending


  # Validations
  validates :status, presence: true
  validates :hours_worked,
            numericality: { greater_than_or_equal_to: 0 },
            allow_nil: true

  validate :completed_requires_completed_event
  validate :hours_within_event_duration
  validate :hours_require_completed_event
  validate :completed_requires_hours_and_date
  validate :event_capacity_available

  after_save :refresh_event_status
  after_destroy :refresh_event_status

  private

  # Custom validations

  def completed_requires_completed_event
    return unless status == "completed"

    errors.add(:status, "can only be completed after the event is completed") unless event&.completed?
  end

  def hours_within_event_duration
    return if hours_worked.blank? || event&.start_time.blank? || event&.end_time.blank?

    duration_hours = ((event.end_time - event.start_time) / 3600.0)
    errors.add(:hours_worked, "cannot exceed the event duration") if hours_worked.to_f > duration_hours
  end

  def hours_require_completed_event
    return if hours_worked.blank?

    errors.add(:hours_worked, "can only be logged for completed events") unless event&.completed?
  end

  def completed_requires_hours_and_date
    return unless status == "completed"

    errors.add(:hours_worked, "must be provided when marking completed") if hours_worked.blank?
    errors.add(:date_logged, "must be provided when marking completed") if date_logged.blank?
  end

  def event_capacity_available
    return unless %w[approved completed].include?(status)
    return if event.blank?

    current_count = event.volunteer_assignments
                         .where(status: %w[approved completed])
                         .where.not(id: id)
                         .count
    if current_count >= event.required_volunteers
      errors.add(:status, "cannot be approved because the event is full")
    end
  end

  

  # Refresh the event status after changes
  def refresh_event_status
    event&.refresh_status!
  end
end