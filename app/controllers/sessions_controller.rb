class SessionsController < ApplicationController
  skip_before_action :require_login, only: [:new, :create]

  def new
    # renders login form
  end

  def create
    user = Admin.find_by(username: params[:username]) || Volunteer.find_by(username: params[:username])

    if user&.authenticate(params[:password])
      reset_session
      if user.is_a?(Admin)
        session[:admin_id] = user.id
        redirect_to admin_dashboard_path, notice: "Welcome back, #{user.name}."
      else
        session[:volunteer_id] = user.id
        redirect_to volunteer_dashboard_path, notice: "Welcome back, #{user.full_name}."
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