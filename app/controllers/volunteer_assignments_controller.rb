class VolunteerAssignmentsController < ApplicationController
  before_action :require_volunteer

  def index
    @assignments = current_volunteer.volunteer_assignments.includes(:event).order(created_at: :desc)
  end

  def history
    @assignments = current_volunteer.volunteer_assignments.completed.includes(:event).order(date_logged: :desc)
    @total_hours = current_volunteer.total_hours
  end

  def create
    event = Event.find(params[:event_id])

    if current_volunteer.volunteer_assignments.where(event: event).where.not(status: %w[cancelled rejected]).exists?
      redirect_to events_path, alert: "You already signed up for this event."
      return
    end

    unless event.can_accept_volunteers?
      redirect_to events_path, alert: "This event is not accepting volunteers."
      return
    end

    assignment = current_volunteer.volunteer_assignments.build(event: event, status: "pending")

    if assignment.save
      redirect_to volunteer_assignments_path, notice: "Signup submitted and pending approval."
    else
      redirect_to events_path, alert: assignment.errors.full_messages.to_sentence
    end
  end

  def destroy
    assignment = current_volunteer.volunteer_assignments.find(params[:id])

    if assignment.status == "completed"
      redirect_to volunteer_assignments_path, alert: "Completed assignments cannot be withdrawn."
      return
    end

    assignment.update(status: "cancelled")
    redirect_to volunteer_assignments_path, notice: "You have withdrawn from the event."
  end
end
