# app/controllers/volunteers_controller.rb
class VolunteersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update, :destroy]

  # Show signup/login page
  def new
    @volunteer = Volunteer.new
  end

  # Create new volunteer
  def create
    @volunteer = Volunteer.new(volunteer_params)
    if @volunteer.save
      reset_session  # Clear any existing session
      session[:volunteer_id] = @volunteer.id
      redirect_to volunteer_dashboard_path, notice: "Account created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Dashboard
  def show
    @volunteer = current_volunteer
    @assignments = @volunteer.volunteer_assignments.order(created_at: :desc)
  end

  # Edit profile
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

  # Delete account / logout
  def destroy
    current_volunteer.destroy
    reset_session
    redirect_to root_path, notice: "Your account has been deleted."
  end

  # Login page
  def login_form
    # Just renders a simple login form
  end

  # Handle login
  def login
    volunteer = Volunteer.find_by(username: params[:username])
    if volunteer&.authenticate(params[:password])
      reset_session
      session[:volunteer_id] = volunteer.id
      redirect_to volunteer_dashboard_path
    else
      flash.now[:alert] = "Invalid username or password"
      render :login_form, status: :unprocessable_entity
    end
  end

  # Logout
  def logout
    reset_session
    redirect_to root_path, notice: "Logged out successfully."
  end

  private

  def volunteer_params
    params.require(:volunteer).permit(:username, :password, :password_confirmation, :full_name, :email, :phone_number, :address, :skills)
  end

  def volunteer_update_params
    params.require(:volunteer).permit(:password, :password_confirmation, :full_name, :email, :phone_number, :address, :skills)
  end
end