class Admin::VolunteerAssignmentsController < ApplicationController
    before_action :require_admin
    before_action :set_assignment, only: %i[edit update destroy]

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

