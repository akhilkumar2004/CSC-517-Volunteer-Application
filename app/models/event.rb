class Event < ApplicationRecord
  has_many :volunteer_assignments, dependent: :destroy
  has_many :volunteers, through: :volunteer_assignments

  enum :status, { open: "open", full: "full", completed: "completed" }, default: :open

  before_validation :set_default_status, on: :create

  validates :title, :description, :location, :event_date, :start_time, :end_time, :status, presence: true
  validates :required_volunteers, presence: true, numericality: { greater_than: 0 }

  validate :start_before_end
  validate :required_volunteers_cannot_change_if_completed, on: :update
  validate :start_time_before_end_time

  # Count approved/completed volunteers
  def assigned_count
    volunteer_assignments.where(status: %w[approved completed]).count
  end

  # Remaining slots
  def available_slots
    [required_volunteers - assigned_count, 0].max
  end

  # Can this event accept new volunteers?
  def can_accept_volunteers?
    open? && available_slots.positive?
  end

  # Refresh status automatically (open/full)
  def refresh_status!
    return if completed?

    next_status = assigned_count >= required_volunteers ? "full" : "open"
    update_column(:status, next_status) if status != next_status
  end

  private

  def set_default_status
    self.status ||= "open"
  end

  def start_before_end
    return if start_time.blank? || end_time.blank?

    errors.add(:start_time, "must be before end time") if start_time >= end_time
  end

  # Prevent changing required_volunteers after completion (optional)
  def required_volunteers_cannot_change_if_completed
    return unless completed?
    return unless will_save_change_to_required_volunteers?

    errors.add(:required_volunteers, "cannot be changed after the event is completed")
  end
  private

  def start_time_before_end_time
    return if start_time.blank? || end_time.blank?

    if start_time > end_time
      errors.add(:start_time, "cannot be later than the end time")
    end
  end

end