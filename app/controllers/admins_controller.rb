class AdminsController < ApplicationController
  before_action :require_login

  def show
    @admin = current_user
  end

  def edit
    @admin = current_user
  end

  def update
    @admin = current_user

    if @admin.update(admin_params)
      redirect_to admin_dashboard_path, notice: "Profile updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def admin_params
    params.require(:admin).permit(:name, :email)
  end
end
