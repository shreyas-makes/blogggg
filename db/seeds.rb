# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create a default admin account for the ActiveAdmin interface
if Rails.env.development?
  AdminUser.create_with(
    password: 'password',
    password_confirmation: 'password'
  ).find_or_create_by!(email: 'admin@example.com')
  
  # Create a regular user with admin privileges
  User.create_with(
    password: 'password',
    password_confirmation: 'password',
    admin: true
  ).find_or_create_by!(email: 'admin@blogggg.com')
  
  # Create a regular non-admin user
  User.create_with(
    password: 'password',
    password_confirmation: 'password',
    admin: false
  ).find_or_create_by!(email: 'user@blogggg.com')
end