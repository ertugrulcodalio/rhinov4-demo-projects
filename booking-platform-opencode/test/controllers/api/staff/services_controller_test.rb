require "test_helper"

class Api::Staff::ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = organizations(:one)
    @admin = @org.staff_members.create!(name: "Admin User", role: "admin", active: true)
    @manager = @org.staff_members.create!(name: "Manager User", role: "manager", active: true)
    @staff = @org.staff_members.create!(name: "Staff User", role: "staff", active: true)
    
    @other_org = Organization.create!(name: "Other Org", email: "other@test.com", slug: "other-org")
    @other_admin = @other_org.staff_members.create!(name: "Other Admin", role: "admin", active: true)
  end

  # Admin tests
  test "admin can list services" do
    get "/api/staff/services", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
    json = JSON.parse(response.body)
    assert json.is_a?(Array)
  end

  test "admin can create service" do
    post "/api/staff/services", params: { service: { name: "New Service", active: true, draft: false } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "New Service", json["name"]
  end

  test "admin can update service" do
    service = @org.services.create!(name: "Old Name", active: true, draft: false)
    
    put "/api/staff/services/#{service.id}", params: { service: { name: "New Name" } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "New Name", json["name"]
  end

  test "admin can destroy service" do
    service = @org.services.create!(name: "To Delete", active: true, draft: false)
    
    delete "/api/staff/services/#{service.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :no_content
    assert service.reload.discarded?
  end

  test "admin can show service" do
    service = @org.services.create!(name: "Shown Service", active: true, draft: false)

    get "/api/staff/services/#{service.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Shown Service", json["name"]
  end

  test "admin cannot access other organization's service" do
    other_service = @other_org.services.create!(name: "Other Service", active: true, draft: false)

    get "/api/staff/services/#{other_service.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  test "admin gets 404 for nonexistent service" do
    get "/api/staff/services/999999", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Manager tests
  test "manager can list services" do
    get "/api/staff/services", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager can create service" do
    post "/api/staff/services", params: { service: { name: "Manager Service", active: true, draft: false } }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :created
  end

  test "manager can update service" do
    service = @org.services.create!(name: "Old Name", active: true, draft: false)
    
    put "/api/staff/services/#{service.id}", params: { service: { name: "Manager Updated" } }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager cannot destroy service" do
    service = @org.services.create!(name: "To Delete", active: true, draft: false)
    
    delete "/api/staff/services/#{service.id}", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :forbidden
  end

  # Staff tests
  test "staff can list services" do
    get "/api/staff/services", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :success
  end

  test "staff cannot create service" do
    post "/api/staff/services", params: { service: { name: "Staff Service", active: true, draft: false } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  test "staff cannot update service" do
    service = @org.services.create!(name: "Old Name", active: true, draft: false)
    
    put "/api/staff/services/#{service.id}", params: { service: { name: "Staff Updated" } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  test "staff cannot destroy service" do
    service = @org.services.create!(name: "To Delete", active: true, draft: false)
    
    delete "/api/staff/services/#{service.id}", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  # Validation and edge case tests
  test "create with missing name returns 422" do
    post "/api/staff/services", params: { service: { active: true } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].any?
  end

  test "update with invalid params returns 422" do
    service = @org.services.create!(name: "Valid", active: true, draft: false)

    put "/api/staff/services/#{service.id}", params: { service: { name: nil } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
  end

  test "discarded service returns 404" do
    service = @org.services.create!(name: "Discarded", active: true, draft: false)
    service.discard

    get "/api/staff/services/#{service.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Unauthorized tests
  test "unauthorized access returns 401" do
    get "/api/staff/services"
    
    assert_response :unauthorized
  end

  test "invalid token returns 401" do
    get "/api/staff/services", headers: { "Authorization" => "Bearer invalid_token" }
    
    assert_response :unauthorized
  end

  test "inactive staff returns 401" do
    inactive = @org.staff_members.create!(name: "Inactive", role: "staff", active: false)
    
    get "/api/staff/services", headers: { "Authorization" => "Bearer #{inactive.api_token}" }
    
    assert_response :unauthorized
  end
end