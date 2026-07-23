require "test_helper"

class Api::BookingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = organizations(:one)
    @service = @org.services.create!(name: "Haircut", active: true, draft: false)
    @time_slot = @org.time_slots.create!(
      service: @service,
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now,
      available: true
    )
    @staff_member = @org.staff_members.create!(name: "John Doe", active: true)
    
    @other_org = Organization.create!(name: "Other Org", email: "other@test.com", slug: "other-org")
    @other_service = @other_org.services.create!(name: "Other Service", active: true, draft: false)
    @other_time_slot = @other_org.time_slots.create!(
      service: @other_service,
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now,
      available: true
    )
    @other_staff_member = @other_org.staff_members.create!(name: "Other Staff", active: true)
  end

  test "create booking with valid data" do
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: @time_slot.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com",
        customer_phone: "555-1234",
        notes: "Please be gentle"
      }
    }
    
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal "pending", json["status"]
    assert_equal "Jane Doe", json["customer_name"]
    assert_equal @service.id, json["service_id"]
    assert_equal @time_slot.id, json["time_slot_id"]
    
    # Time slot should now be unavailable
    @time_slot.reload
    assert_not @time_slot.available
  end

  test "create booking with staff member" do
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: @time_slot.id,
        staff_member_id: @staff_member.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :created
    json = JSON.parse(response.body)
    assert_equal @staff_member.id, json["staff_member_id"]
  end

  test "create booking fails with service from other organization" do
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @other_service.id,
        time_slot_id: @time_slot.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Service not available"
  end

  test "create booking fails with time slot from other organization" do
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: @other_time_slot.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Time slot not available"
  end

  test "create booking fails with time slot not belonging to service" do
    other_service = @org.services.create!(name: "Manicure", active: true, draft: false)
    other_slot = @org.time_slots.create!(
      service: other_service,
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now,
      available: true
    )
    
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: other_slot.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Time slot does not belong to the selected service"
  end

  test "create booking fails with inactive service" do
    inactive_service = @org.services.create!(name: "Closed", active: false, draft: false)
    slot = @org.time_slots.create!(
      service: inactive_service,
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now,
      available: true
    )
    
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: inactive_service.id,
        time_slot_id: slot.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Service not available"
  end

  test "create booking fails with unavailable time slot" do
    unavailable_slot = @org.time_slots.create!(
      service: @service,
      start_time: 3.hours.from_now,
      end_time: 4.hours.from_now,
      available: false
    )
    
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: unavailable_slot.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Time slot not available"
  end

  test "create booking fails with staff member from other organization" do
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: @time_slot.id,
        staff_member_id: @other_staff_member.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Staff member not available"
  end

  test "create booking fails with inactive staff member" do
    inactive_staff = @org.staff_members.create!(name: "Inactive", active: false)
    
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: @time_slot.id,
        staff_member_id: inactive_staff.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Staff member not available"
  end

  test "create booking fails without required fields" do
    post "/api/#{@org.slug}/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: @time_slot.id
      }
    }
    
    assert_response :unprocessable_entity
    json = JSON.parse(response.body)
    assert_includes json["errors"], "Customer name can't be blank"
    assert_includes json["errors"], "Customer email can't be blank"
  end

  test "create booking fails with invalid organization slug" do
    post "/api/invalid-slug/bookings", params: {
      booking: {
        service_id: @service.id,
        time_slot_id: @time_slot.id,
        customer_name: "Jane Doe",
        customer_email: "jane@example.com"
      }
    }
    
    assert_response :not_found
  end
end