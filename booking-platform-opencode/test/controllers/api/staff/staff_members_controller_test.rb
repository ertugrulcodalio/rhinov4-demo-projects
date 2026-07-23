require "test_helper"

class Api::Staff::StaffMembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = organizations(:one)
    @admin = @org.staff_members.create!(name: "Admin User", role: "admin", active: true)
    @manager = @org.staff_members.create!(name: "Manager User", role: "manager", active: true)
    @staff = @org.staff_members.create!(name: "Staff User", role: "staff", active: true)
    
    @other_org = Organization.create!(name: "Other Org", email: "other@test.com", slug: "other-org")
    @other_admin = @other_org.staff_members.create!(name: "Other Admin", role: "admin", active: true)
  end

  # Admin tests
  test "admin can list staff members" do
    get "/api/staff/staff_members", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
    json = JSON.parse(response.body)
    assert json.is_a?(Array)
  end

  test "admin can create staff member" do
    post "/api/staff/staff_members", params: { staff_member: { name: "New Staff", role: "staff", email: "new@test.com", active: true } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "New Staff", json["name"]
  end

  test "admin can update staff member" do
    staff = @org.staff_members.create!(name: "Old Name", role: "staff", active: true)
    
    put "/api/staff/staff_members/#{staff.id}", params: { staff_member: { name: "Updated Name" } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Updated Name", json["name"]
  end

  test "admin can destroy staff member" do
    staff = @org.staff_members.create!(name: "To Delete", role: "staff", active: true)
    
    delete "/api/staff/staff_members/#{staff.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :no_content
    assert staff.reload.discarded?
  end

  test "admin cannot access other organization's staff member" do
    other_staff = @other_org.staff_members.create!(name: "Other Staff", role: "staff", active: true)
    
    get "/api/staff/staff_members/#{other_staff.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :not_found
  end

  test "admin can show staff member" do
    member = @org.staff_members.create!(name: "Shown Member", role: "staff", active: true)

    get "/api/staff/staff_members/#{member.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Shown Member", json["name"]
  end

  test "admin gets 404 for nonexistent staff member" do
    get "/api/staff/staff_members/999999", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Manager tests
  test "manager can list staff members" do
    get "/api/staff/staff_members", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager can create staff member" do
    post "/api/staff/staff_members", params: { staff_member: { name: "Manager Staff", role: "staff", email: "mgr@test.com", active: true } }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :created
  end

  test "manager can update staff member" do
    staff = @org.staff_members.create!(name: "Old Name", role: "staff", active: true)
    
    put "/api/staff/staff_members/#{staff.id}", params: { staff_member: { name: "Manager Updated" } }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager cannot destroy staff member" do
    staff = @org.staff_members.create!(name: "To Delete", role: "staff", active: true)
    
    delete "/api/staff/staff_members/#{staff.id}", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :forbidden
  end

  # Staff tests
  test "staff can list staff members" do
    get "/api/staff/staff_members", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :success
    json = JSON.parse(response.body)
    assert json.is_a?(Array)
  end

  test "staff can show own profile" do
    get "/api/staff/staff_members/#{@staff.id}", headers: { "Authorization" => "Bearer #{@staff.api_token}" }

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @staff.id, json["id"]
  end

  test "staff cannot show other staff member" do
    other = @org.staff_members.create!(name: "Other", role: "staff", active: true)

    get "/api/staff/staff_members/#{other.id}", headers: { "Authorization" => "Bearer #{@staff.api_token}" }

    assert_response :forbidden
  end

  test "staff can update own profile" do
    put "/api/staff/staff_members/#{@staff.id}", params: { staff_member: { name: "My Updated Name" } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "My Updated Name", json["name"]
  end

  test "staff cannot update other staff member" do
    other = @org.staff_members.create!(name: "Other", role: "staff", active: true)

    put "/api/staff/staff_members/#{other.id}", params: { staff_member: { name: "Hacked" } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }

    assert_response :forbidden
  end

  test "staff cannot create staff member" do
    post "/api/staff/staff_members", params: { staff_member: { name: "Staff Staff", role: "staff", email: "staff@test.com", active: true } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  test "staff cannot update staff member" do
    staff = @org.staff_members.create!(name: "Old Name", role: "staff", active: true)
    
    put "/api/staff/staff_members/#{staff.id}", params: { staff_member: { name: "Staff Updated" } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  test "staff cannot destroy staff member" do
    staff = @org.staff_members.create!(name: "To Delete", role: "staff", active: true)
    
    delete "/api/staff/staff_members/#{staff.id}", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  # Validation and edge case tests
  test "create with missing name returns 422" do
    post "/api/staff/staff_members", params: { staff_member: { role: "staff", active: true } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].any?
  end

  test "update with invalid params returns 422" do
    member = @org.staff_members.create!(name: "Valid", role: "staff", active: true)

    put "/api/staff/staff_members/#{member.id}", params: { staff_member: { name: nil } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
  end

  test "discarded staff member returns 404" do
    member = @org.staff_members.create!(name: "Discarded", role: "staff", active: true)
    member.discard

    get "/api/staff/staff_members/#{member.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Unauthorized tests
  test "unauthorized access returns 401" do
    get "/api/staff/staff_members"
    
    assert_response :unauthorized
  end

  test "invalid token returns 401" do
    get "/api/staff/staff_members", headers: { "Authorization" => "Bearer invalid_token" }
    
    assert_response :unauthorized
  end

  test "inactive staff returns 401" do
    inactive = @org.staff_members.create!(name: "Inactive", role: "staff", active: false)
    
    get "/api/staff/staff_members", headers: { "Authorization" => "Bearer #{inactive.api_token}" }
    
    assert_response :unauthorized
  end
end