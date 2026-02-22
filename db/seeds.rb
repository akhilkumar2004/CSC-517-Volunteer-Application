# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
Admin.find_or_create_by!(username: "admin") do |admin|
	admin.password = "Password123!"
	admin.password_confirmation = "Password123!"
	admin.name = "Primary Admin"
	admin.email = "admin@example.com"
end
