class Volunteer < ApplicationRecord
  before_create :set_volunteer_number

  has_secure_password

  has_many :volunteer_assignments, dependent: :destroy
  has_many :events, through: :volunteer_assignments

  # Required fields
  validates :username, presence: { message: "is required" }, uniqueness: true
  validates :full_name, presence: { message: "is required" }
  validates :email,
            presence: true,
            uniqueness: true,
            format: { 
              with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
              message: "must be a valid email address"
            }

  # Password validations
  validates :password,
            length: { minimum: 6, message: "must be at least 6 characters" },
            confirmation: { message: "does not match" },
            if: -> { password.present? }

  # Optional phone
  validates :phone_number,
            format: { with: /\A\d{10}\z/, message: "must be exactly 10 digits" },
            allow_blank: true

  def set_volunteer_number
    last_number = Volunteer.maximum(:volunteer_number) || 0
    self.volunteer_number = last_number + 1
  end

  def total_hours
  volunteer_assignments.sum(:hours_worked).to_f
end

end