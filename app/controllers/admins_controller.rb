class AdminsController < ApplicationController
  before_action :require_admin

  def show
    @admin = current_admin
  end

  def edit
    @admin = current_admin
  end

  def update
    @admin = current_admin

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
