class AdminSessionsController < ApplicationController
  def new
  end

  def create
    admin = Admin.find_by(username: params[:username])

    if admin&.authenticate(params[:password])
      reset_session
      session[:admin_id] = admin.id
      redirect_to admin_dashboard_path, notice: "Welcome back, #{admin.name}."
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
