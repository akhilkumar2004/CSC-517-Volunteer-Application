class VolunteerSessionsController < ApplicationController
  def new
  end

  def create
    volunteer = Volunteer.find_by(username: params[:username])

    if volunteer&.authenticate(params[:password])
      reset_session
      session[:volunteer_id] = volunteer.id
      redirect_to volunteer_dashboard_path, notice: "Welcome back, #{volunteer.full_name}."
    else
      flash.now[:alert] = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "You have logged out."
  end
end
