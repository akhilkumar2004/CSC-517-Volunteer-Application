class Admin::VolunteerAssignmentsController < ApplicationController
  before_action :require_login
  before_action :set_assignment, only: %i[edit update destroy approve]

  def approve
    @assignment = VolunteerAssignment.find_by(id: params[:id])
    unless @assignment
      redirect_to admin_volunteer_assignments_path, alert: "Assignment not found." and return
    end

    unless @assignment.volunteer.signed_up_for_event?(@assignment.event)
      redirect_to admin_volunteer_assignments_path, alert: "Volunteer did not sign up for this event." and return
    end

    approved_count = @assignment.event.volunteer_assignments.where(status: 'approved').count
    if approved_count >= @assignment.event.capacity
      redirect_to admin_volunteer_assignments_path, alert: "Cannot approve: Event is already full." and return
    end

    if @assignment.update(status: 'approved')
      redirect_to admin_volunteer_assignments_path, notice: "Volunteer assignment approved."
    else
      redirect_to admin_volunteer_assignments_path, alert: @assignment.errors.full_messages.to_sentence
    end
  end

  def index
    @assignments = VolunteerAssignment.includes(:volunteer, :event).order(created_at: :desc)
  end

  def new
    @assignment = VolunteerAssignment.new
    load_options
  end

  def create
    @assignment = VolunteerAssignment.new(assignment_params)

    if @assignment.save
      redirect_to admin_volunteer_assignments_path, notice: "Assignment created."
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      load_options
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_options
  end

  def update
    if @assignment.update(assignment_params)
      redirect_to admin_volunteer_assignments_path, notice: "Assignment updated."
    else
      flash.now[:alert] = @assignment.errors.full_messages.to_sentence
      load_options
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @assignment.destroy
    redirect_to admin_volunteer_assignments_path, notice: "Assignment removed."
  end

  private

  def set_assignment
    @assignment = VolunteerAssignment.find(params[:id])
  end

  def assignment_params
    params.require(:volunteer_assignment).permit(:volunteer_id, :event_id, :status, :hours_worked, :date_logged)
  end

  def load_options
    @volunteers = Volunteer.order(:full_name)
    @events = Event.order(event_date: :asc)
  end
end
