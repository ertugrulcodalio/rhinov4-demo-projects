require "test_helper"

class BookingTest < ActiveSupport::TestCase
  # --- Validations ---

  test "valid booking with required attributes" do
    booking = build_valid_booking
    assert booking.valid?
  end

  test "requires customer_name" do
    booking = build_valid_booking(customer_name: nil)
    assert_not booking.valid?
    assert_includes booking.errors[:customer_name], "can't be blank"
  end

  test "customer_name must be at most 255 characters" do
    booking = build_valid_booking(customer_name: "x" * 256)
    assert_not booking.valid?
    assert_includes booking.errors[:customer_name], "is too long (maximum is 255 characters)"
  end

  test "requires customer_email" do
    booking = build_valid_booking(customer_email: nil)
    assert_not booking.valid?
    assert_includes booking.errors[:customer_email], "can't be blank"
  end

  test "customer_email must be at most 255 characters" do
    booking = build_valid_booking(customer_email: "x" * 256)
    assert_not booking.valid?
    assert_includes booking.errors[:customer_email], "is too long (maximum is 255 characters)"
  end

  test "customer_phone is optional" do
    booking = build_valid_booking(customer_phone: nil)
    assert booking.valid?
  end

  test "customer_phone must be at most 50 characters" do
    booking = build_valid_booking(customer_phone: "x" * 51)
    assert_not booking.valid?
    assert_includes booking.errors[:customer_phone], "is too long (maximum is 50 characters)"
  end

  test "notes is optional" do
    booking = build_valid_booking(notes: nil)
    assert booking.valid?
  end

  test "notes must be at most 2000 characters" do
    booking = build_valid_booking(notes: "x" * 2001)
    assert_not booking.valid?
    assert_includes booking.errors[:notes], "is too long (maximum is 2000 characters)"
  end

  test "status defaults to pending" do
    booking = Booking.new
    assert_equal "pending", booking.status
  end

  test "requires organization" do
    booking = build_valid_booking
    booking.organization = nil
    assert_not booking.valid?
    assert_includes booking.errors[:organization], "must exist"
  end

  test "requires service" do
    booking = build_valid_booking(service: nil)
    assert_not booking.valid?
    assert_includes booking.errors[:service], "must exist"
  end

  test "requires time_slot" do
    booking = build_valid_booking(time_slot: nil)
    assert_not booking.valid?
    assert_includes booking.errors[:time_slot], "must exist"
  end

  test "staff_member is optional" do
    booking = build_valid_booking(staff_member: nil)
    assert booking.valid?
  end

  # --- Status Inclusion ---

  test "accepts valid statuses" do
    %w[pending confirmed cancelled completed].each do |status|
      booking = build_valid_booking(status: status)
      assert booking.valid?, "Expected status '#{status}' to be valid"
    end
  end

  test "rejects invalid status" do
    booking = build_valid_booking(status: "unknown")
    assert_not booking.valid?
    assert_includes booking.errors[:status], "is not included in the list"
  end

  # --- Tenant Isolation: Service must belong to organization ---

  test "service must belong to same organization" do
    other_org = Organization.create!(name: "Other", email: "other@x.com")
    other_service = Service.create!(name: "Other Svc", organization: other_org)

    booking = build_valid_booking(service: other_service)
    assert_not booking.valid?
    assert_includes booking.errors[:service_id], "does not belong to your organization"
  end

  # --- Tenant Isolation: Time slot must belong to organization ---

  test "time_slot must belong to same organization" do
    other_org = Organization.create!(name: "Other", email: "other@x.com")
    other_service = Service.create!(name: "Other Svc", organization: other_org)
    other_slot = TimeSlot.create!(
      organization: other_org, service: other_service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )

    booking = build_valid_booking(time_slot: other_slot)
    assert_not booking.valid?
    assert_includes booking.errors[:time_slot_id], "does not belong to your organization"
  end

  # --- Tenant Isolation: Staff member must belong to organization ---

  test "staff_member must belong to same organization when present" do
    other_org = Organization.create!(name: "Other", email: "other@x.com")
    other_member = StaffMember.create!(name: "Other Staff", organization: other_org)

    booking = build_valid_booking(staff_member: other_member)
    assert_not booking.valid?
    assert_includes booking.errors[:staff_member_id], "does not belong to your organization"
  end

  test "staff_member from same organization is accepted" do
    member = StaffMember.create!(name: "Staff", organization: @org, active: true)
    booking = build_valid_booking(staff_member: member)
    assert booking.valid?
  end

  # --- Business Rule: Service must be active ---

  test "rejects booking for inactive service" do
    inactive_service = Service.create!(name: "Closed", organization: @org, active: false)
    slot = TimeSlot.create!(
      organization: @org, service: inactive_service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )

    booking = build_valid_booking(service: inactive_service, time_slot: slot)
    assert_not booking.valid?
    assert_includes booking.errors[:service_id], "is not active"
  end

  # --- Business Rule: Time slot must be available ---

  test "rejects booking for unavailable time slot" do
    slot = TimeSlot.create!(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      available: false
    )

    booking = build_valid_booking(time_slot: slot)
    assert_not booking.valid?
    assert_includes booking.errors[:time_slot_id], "is not available"
  end

  # --- Business Rule: Time slot must belong to the selected service ---

  test "rejects booking when time_slot belongs to different service" do
    other_service = Service.create!(name: "Manicure", organization: @org)
    other_slot = TimeSlot.create!(
      organization: @org, service: other_service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )

    booking = build_valid_booking(time_slot: other_slot)
    assert_not booking.valid?
    assert_includes booking.errors[:time_slot_id], "does not belong to the selected service"
  end

  # --- Soft Deletes ---

  test "discard soft-deletes the record" do
    booking = create_valid_booking!
    booking.discard
    assert_not_nil booking.discarded_at
    assert_not_includes Booking.kept, booking
  end

  test "kept scope excludes discarded records" do
    active = create_valid_booking!
    discarded = create_valid_booking!
    discarded.discard

    assert_includes Booking.kept, active
    assert_not_includes Booking.kept, discarded
  end

  # --- Scopes ---

  test "by_status scope filters correctly" do
    pending = create_valid_booking!(status: "pending")
    confirmed = create_valid_booking!(status: "confirmed")

    assert_equal [pending], Booking.by_status("pending").to_a
    assert_equal [confirmed], Booking.by_status("confirmed").to_a
  end

  private

  def build_valid_booking(**overrides)
    service = @service
    slot = TimeSlot.find_by(organization: @org, service: service) ||
           TimeSlot.create!(
             organization: @org, service: service,
             start_time: 1.hour.from_now, end_time: 2.hours.from_now
           )

    Booking.new(
      organization: @org,
      service: service,
      time_slot: slot,
      customer_name: "Jane Doe",
      customer_email: "jane@example.com",
      **overrides
    )
  end

  def create_valid_booking!(**overrides)
    service = @service
    slot = TimeSlot.find_by(organization: @org, service: service) ||
           TimeSlot.create!(
             organization: @org, service: service,
             start_time: 1.hour.from_now, end_time: 2.hours.from_now
           )

    Booking.create!(
      organization: @org,
      service: service,
      time_slot: slot,
      customer_name: "Jane Doe",
      customer_email: "jane@example.com",
      **overrides
    )
  end
end
