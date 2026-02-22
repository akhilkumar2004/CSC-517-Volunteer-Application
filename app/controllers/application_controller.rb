class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_volunteer, :current_admin, :volunteer_signed_in?, :admin_signed_in?

  private

  def current_volunteer
    return @current_volunteer if defined?(@current_volunteer)

    @current_volunteer = Volunteer.find_by(id: session[:volunteer_id])
  end

  def current_admin
    return @current_admin if defined?(@current_admin)

    @current_admin = Admin.find_by(id: session[:admin_id])
  end

  def volunteer_signed_in?
    current_volunteer.present?
  end

  def admin_signed_in?
    current_admin.present?
  end

  def require_volunteer
    return if volunteer_signed_in?

    redirect_to volunteer_login_path, alert: "Please log in as a volunteer."
  end

  def require_admin
    return if admin_signed_in?

    redirect_to admin_login_path, alert: "Please log in as an admin."
  end
end
