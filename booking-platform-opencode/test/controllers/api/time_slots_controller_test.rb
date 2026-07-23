require "test_helper"

class Api::TimeSlotsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = organizations(:one)
    @service = @org.services.create!(name: "Haircut", active: true, draft: false)
    @available_slot = @org.time_slots.create!(
      service: @service,
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now,
      available: true
    )
    @unavailable_slot = @org.time_slots.create!(
      service: @service,
      start_time: 3.hours.from_now,
      end_time: 4.hours.from_now,
      available: false
    )
    @discarded_slot = @org.time_slots.create!(
      service: @service,
      start_time: 5.hours.from_now,
      end_time: 6.hours.from_now,
      available: true
    )
    @discarded_slot.discard
    
    @other_org = Organization.create!(name: "Other Org", email: "other@test.com", slug: "other-org")
    @other_service = @other_org.services.create!(name: "Other Service", active: true, draft: false)
    @other_slot = @other_org.time_slots.create!(
      service: @other_service,
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now,
      available: true
    )
  end

  test "index returns only available slots for organization" do
    get "/api/#{@org.slug}/time_slots"
    
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal 1, json.length
    assert_equal @available_slot.id, json.first["id"]
  end

  test "index does not return unavailable slots" do
    get "/api/#{@org.slug}/time_slots"
    
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_not_includes ids, @unavailable_slot.id
  end

  test "index does not return discarded slots" do
    get "/api/#{@org.slug}/time_slots"
    
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_not_includes ids, @discarded_slot.id
  end

  test "index does not return slots from other organizations" do
    get "/api/#{@org.slug}/time_slots"
    
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_not_includes ids, @other_slot.id
  end

  test "show returns available slot from same organization" do
    get "/api/#{@org.slug}/time_slots/#{@available_slot.id}"
    
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @available_slot.id, json["id"]
  end

  test "show returns 404 for slot from other organization" do
    get "/api/#{@org.slug}/time_slots/#{@other_slot.id}"
    
    assert_response :not_found
  end

  test "show returns 404 for unavailable slot" do
    get "/api/#{@org.slug}/time_slots/#{@unavailable_slot.id}"
    
    assert_response :not_found
  end

  test "show returns 404 for discarded slot" do
    get "/api/#{@org.slug}/time_slots/#{@discarded_slot.id}"
    
    assert_response :not_found
  end
end