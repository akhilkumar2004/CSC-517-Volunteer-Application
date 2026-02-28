class ApplicationController < ActionController::Base
  # Use before_action here to make it available to all controllers
  before_action :require_login

  helper_method :current_volunteer, :current_admin, :current_user, 
                :volunteer_signed_in?, :admin_signed_in?, :signed_in?

  private

  def require_login
    unless signed_in?
      redirect_to root_path, alert: "Please log in first."
    end
  end

  def current_volunteer
    @current_volunteer ||= Volunteer.find_by(id: session[:volunteer_id])
  end

  def current_admin
    @current_admin ||= Admin.find_by(id: session[:admin_id])
  end

  def current_user
    current_admin || current_volunteer
  end

  def volunteer_signed_in?
    current_volunteer.present?
  end

  def admin_signed_in?
    current_admin.present?
  end

  def signed_in?
    current_user.present?
  end
end