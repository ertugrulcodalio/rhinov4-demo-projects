require "test_helper"

class Api::Staff::BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = organizations(:one)
    @service = @org.services.create!(name: "Haircut", active: true, draft: false)
    @time_slot = @org.time_slots.create!(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    @staff_member = @org.staff_members.create!(name: "John Doe", role: "staff", active: true)
    
    @admin = @org.staff_members.create!(name: "Admin User", role: "admin", active: true)
    @manager = @org.staff_members.create!(name: "Manager User", role: "manager", active: true)
    @staff = @org.staff_members.create!(name: "Staff User", role: "staff", active: true)
    
    @other_org = Organization.create!(name: "Other Org", email: "other@test.com", slug: "other-org")
    @other_service = @other_org.services.create!(name: "Other Service", active: true, draft: false)
    @other_time_slot = @other_org.time_slots.create!(service: @other_service, start_time: 1.hour.from_now, end_time: 2.hours.from_now, available: true)
    @other_admin = @other_org.staff_members.create!(name: "Other Admin", role: "admin", active: true)
  end

  # Admin tests
  test "admin can list bookings" do
    get "/api/staff/bookings", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
  end

  test "admin can create booking" do
    post "/api/staff/bookings", params: { 
      booking: { 
        service_id: @service.id, 
        time_slot_id: @time_slot.id, 
        customer_name: "Jane Doe", 
        customer_email: "jane@example.com", 
        status: "pending" 
      } 
    }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :created
  end

  test "admin can update booking" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Test", customer_email: "test@test.com", status: "pending")
    
    put "/api/staff/bookings/#{booking.id}", params: { booking: { status: "confirmed" } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :success
    assert_equal "confirmed", JSON.parse(response.body)["status"]
  end

  test "admin can destroy booking" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Test", customer_email: "test@test.com", status: "pending")
    
    delete "/api/staff/bookings/#{booking.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :no_content
    assert booking.reload.discarded?
  end

  test "admin cannot access other organization's booking" do
    other_booking = @other_org.bookings.create!(service: @other_service, time_slot: @other_time_slot, customer_name: "Other", customer_email: "other@test.com", status: "pending")
    
    get "/api/staff/bookings/#{other_booking.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }
    
    assert_response :not_found
  end

  test "admin can show booking" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Shown", customer_email: "shown@test.com", status: "pending")

    get "/api/staff/bookings/#{booking.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :success
    json = JSON.parse(response.body)
    assert_equal "Shown", json["customer_name"]
  end

  test "admin gets 404 for nonexistent booking" do
    get "/api/staff/bookings/999999", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Manager tests
  test "manager can list bookings" do
    get "/api/staff/bookings", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager can create booking" do
    post "/api/staff/bookings", params: { 
      booking: { 
        service_id: @service.id, 
        time_slot_id: @time_slot.id, 
        customer_name: "Jane Doe", 
        customer_email: "jane@example.com", 
        status: "pending" 
      } 
    }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :created
  end

  test "manager can update booking" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Test", customer_email: "test@test.com", status: "pending")
    
    put "/api/staff/bookings/#{booking.id}", params: { booking: { status: "confirmed" } }, headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :success
  end

  test "manager can destroy booking" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Test", customer_email: "test@test.com", status: "pending")
    
    delete "/api/staff/bookings/#{booking.id}", headers: { "Authorization" => "Bearer #{@manager.api_token}" }
    
    assert_response :no_content
  end

  # Staff tests
  test "staff can list bookings" do
    get "/api/staff/bookings", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :success
  end

  test "staff can create booking" do
    post "/api/staff/bookings", params: { 
      booking: { 
        service_id: @service.id, 
        time_slot_id: @time_slot.id, 
        customer_name: "Jane Doe", 
        customer_email: "jane@example.com", 
        status: "pending" 
      } 
    }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :created
  end

  test "staff cannot update booking" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Test", customer_email: "test@test.com", status: "pending")
    
    put "/api/staff/bookings/#{booking.id}", params: { booking: { status: "confirmed" } }, headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  test "staff cannot destroy booking" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Test", customer_email: "test@test.com", status: "pending")
    
    delete "/api/staff/bookings/#{booking.id}", headers: { "Authorization" => "Bearer #{@staff.api_token}" }
    
    assert_response :forbidden
  end

  # Validation and edge case tests
  test "create with missing customer_name returns 422" do
    post "/api/staff/bookings", params: {
      booking: { service_id: @service.id, time_slot_id: @time_slot.id, customer_email: "test@test.com" }
    }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert json["errors"].any?
  end

  test "update with invalid params returns 422" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Valid", customer_email: "test@test.com", status: "pending")

    put "/api/staff/bookings/#{booking.id}", params: { booking: { customer_name: nil } }, headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :unprocessable_entity
  end

  test "discarded booking returns 404" do
    booking = @org.bookings.create!(service: @service, time_slot: @time_slot, customer_name: "Discarded", customer_email: "test@test.com", status: "pending")
    booking.discard

    get "/api/staff/bookings/#{booking.id}", headers: { "Authorization" => "Bearer #{@admin.api_token}" }

    assert_response :not_found
  end

  # Unauthorized tests
  test "unauthorized access returns 401" do
    get "/api/staff/bookings"
    
    assert_response :unauthorized
  end

  test "invalid token returns 401" do
    get "/api/staff/bookings", headers: { "Authorization" => "Bearer invalid_token" }
    
    assert_response :unauthorized
  end

  test "inactive staff returns 401" do
    inactive = @org.staff_members.create!(name: "Inactive", role: "staff", active: false)
    
    get "/api/staff/bookings", headers: { "Authorization" => "Bearer #{inactive.api_token}" }
    
    assert_response :unauthorized
  end
end