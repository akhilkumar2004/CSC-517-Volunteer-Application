class Admin < ApplicationRecord
  has_secure_password

  before_create :set_admin_number

  validates :username, presence: true, uniqueness: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  private

  def set_admin_number
    # set as the next available number
    self.admin_number = Admin.maximum(:admin_number).to_i + 1
  end
end