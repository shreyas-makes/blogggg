require 'rails_helper'

RSpec.describe "Infrastructure", type: :request do
  describe "Health Check" do
    it "returns a health check response" do
      get "/health"
      expect(response).to have_http_status(:success).or have_http_status(:service_unavailable)
      
      json_response = JSON.parse(response.body)
      expect(json_response["status"]).to eq("ok")
      # In test environment, database should be connected
      expect(json_response["database_connection"]).to eq(true)
      # Other services might not be running in test environment
    end
  end
  
  describe "Authentication" do
    it "allows access to public pages" do
      get "/"
      expect(response).to have_http_status(:success)
    end
    
    it "redirects unauthenticated users from admin pages" do
      get "/admin"
      expect(response).to redirect_to(new_admin_user_session_path)
    end
  end
  
  describe "ActiveAdmin" do
    it "has a working admin dashboard" do
      admin = AdminUser.create!(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      sign_in admin
      
      get "/admin"
      expect(response).to have_http_status(:success)
    end
  end
end 