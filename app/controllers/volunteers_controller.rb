class VolunteersController < ApplicationController
  before_action :require_volunteer, only: %i[show edit update destroy]

  def show
    @volunteer = current_volunteer
    @assignments = @volunteer.volunteer_assignments.order(created_at: :desc)
  end

  def new
    @volunteer = Volunteer.new
  end

  def create
    @volunteer = Volunteer.new(volunteer_params)

    if @volunteer.save
      reset_session
      session[:volunteer_id] = @volunteer.id
      redirect_to volunteer_dashboard_path, notice: "Account created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @volunteer = current_volunteer
  end

  def update
    @volunteer = current_volunteer

    if @volunteer.update(volunteer_update_params)
      redirect_to volunteer_dashboard_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    current_volunteer.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted."
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:username, :password, :password_confirmation, :full_name, :email, :phone_number, :address, :skills)
  end

  def volunteer_update_params
    params.require(:volunteer).permit(:password, :password_confirmation, :full_name, :email, :phone_number, :address, :skills)
  end
end
