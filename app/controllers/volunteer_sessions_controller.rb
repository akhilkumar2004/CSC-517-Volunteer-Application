class SessionsController < ApplicationController
  def new
  end

  def create
    user = Volunteer.find_by(username: params[:username]) ||
           Admin.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      reset_session

      if user.is_a?(Volunteer)
        session[:volunteer_id] = user.id
        redirect_to volunteer_dashboard_path, notice: "Welcome back, #{user.full_name}."
      else
        session[:admin_id] = user.id
        redirect_to admin_dashboard_path, notice: "Welcome back, Admin."
      end
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