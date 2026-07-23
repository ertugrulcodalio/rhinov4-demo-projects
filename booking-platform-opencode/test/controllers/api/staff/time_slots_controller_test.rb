require "test_helper"

class Api::Staff::TimeSlotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = organizations(:one)
    @service = @org.services.create!(name: "Haircut", active: true, draft: false)
    
    @admin = @org.staff_members.create!(name: "Admin User", role: "admin", active: true)
    @manager = @org.staff_members.create!(name: "Manager User", role: "manager", active: true)
    @staff = @org.staff_members.create!(name: "Staff User", role: "staff", active: true)
    
    @other_org = Organization.create!(name: "Other Org", email: "other@test.com", slug: "other-org")
    @other_service = @other_org.services.create!(name: "Other Service", active: true, draft: false)
    @other_admin = @other_org.staff_members.create!(name: "Other Admin", role: "admin", active: true)
  end

  # Admin tests
  test "admin can list time slots" do
    get "/api/staff/time_slots", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
  end

  test "admin can create time slot" do
    post "/api/staff/time_slots", params: { 
      time_slot: { 
        service_id: @service.id, 
        start_time: 1.hour.from_now.iso8601, 
        end_time: 2.hours.from_now.iso8601, 
        available: true 
      } 
    }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :created
  end

  test "admin can update time slot" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    
    put "/api/staff/time_slots/#{slot.id}", params: { time_slot: { available: false } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
    assert_equal false, JSON.parse(response.body)["available"]
  end

  test "admin can destroy time slot" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    
    delete "/api/staff/time_slots/#{slot.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :no_content
    assert slot.reload.discarded?
  end

  test "admin cannot access other organization's time slot" do
    other_slot = @other_org.time_slots.create!(service: @other_service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    
    get "/api/staff/time_slots/#{other_slot.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :not_found
  end

  test "admin can show time slot" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)

    get "/api/staff/time_slots/#{slot.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal slot.id, json["id"]
  end

  test "admin gets 404 for nonexistent time slot" do
    get "/api/staff/time_slots/999999", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Manager tests
  test "manager can list time slots" do
    get "/api/staff/time_slots", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager can create time slot" do
    post "/api/staff/time_slots", params: { 
      time_slot: { 
        service_id: @service.id, 
        start_time: 1.hour.from_now.iso8601, 
        end_time: 2.hours.from_now.iso8601, 
        available: true 
      } 
    }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :created
  end

  test "manager can update time slot" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    
    put "/api/staff/time_slots/#{slot.id}", params: { time_slot: { available: false } }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager can destroy time slot" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    
    delete "/api/staff/time_slots/#{slot.id}", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :no_content
  end

  # Staff tests
  test "staff can list time slots" do
    get "/api/staff/time_slots", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :success
  end

  test "staff cannot create time slot" do
    post "/api/staff/time_slots", params: { 
      time_slot: { 
        service_id: @service.id, 
        start_time: 1.hour.from_now.iso8601, 
        end_time: 2.hours.from_now.iso8601, 
        available: true 
      } 
    }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  test "staff can update time slot" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    
    put "/api/staff/time_slots/#{slot.id}", params: { time_slot: { available: false } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :success
  end

  test "staff cannot destroy time slot" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    
    delete "/api/staff/time_slots/#{slot.id}", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  # Validation and edge case tests
  test "create with missing start_time returns 422" do
    post "/api/staff/time_slots", params: {
      time_slot: { service_id: @service.id, end_time: 2.hours.from_now.iso8601 }
    }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].any?
  end

  test "update with invalid params returns 422" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)

    put "/api/staff/time_slots/#{slot.id}", params: { time_slot: { start_time: nil, end_time: nil } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
  end

  test "discarded time slot returns 404" do
    slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    slot.discard

    get "/api/staff/time_slots/#{slot.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Unauthorized tests
  test "unauthorized access returns 401" do
    get "/api/staff/time_slots"
    
    assert_response :unauthorized
  end

  test "invalid token returns 401" do
    get "/api/staff/time_slots", headers: { "Authorization" => "Bearer invalid_token" }
    
    assert_response :unauthorized
  end

  test "inactive staff returns 401" do
    inactive = @org.staff_members.create!(name: "Inactive", role: "staff", active: false)
    
    get "/api/staff/time_slots", headers: { "Authorization" => "Bearer #{inactive.api_token}" }
    
    assert_response :unauthorized
  end
end