require "test_helper"

class TimeSlotTest < ActiveSupport::TestCase
  # --- Validations ---

  test "valid time slot with required attributes" do
    slot = TimeSlot.new(
      organization: @org,
      service: @service,
      start_time: 1.hour.from_now,
      end_time: 2.hours.from_now
    )
    assert slot.valid?
  end

  test "requires start_time" do
    slot = TimeSlot.new(organization: @org, service: @service, end_time: 1.hour.from_now)
    assert_not slot.valid?
    assert_includes slot.errors[:start_time], "can't be blank"
  end

  test "requires end_time" do
    slot = TimeSlot.new(organization: @org, service: @service, start_time: 1.hour.from_now)
    assert_not slot.valid?
    assert_includes slot.errors[:end_time], "can't be blank"
  end

  test "end_time must be after start_time" do
    now = Time.current
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: now, end_time: now - 1.hour
    )
    assert_not slot.valid?
    assert_includes slot.errors[:end_time], "must be after start_time"
  end

  test "end_time equal to start_time is invalid" do
    now = Time.current
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: now, end_time: now
    )
    assert_not slot.valid?
    assert_includes slot.errors[:end_time], "must be after start_time"
  end

  test "available defaults to true" do
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    assert_equal true, slot.available
  end

  test "available must be boolean-like" do
    slot_true = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      available: true
    )
    assert slot_true.valid?
    slot_false = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      available: false
    )
    assert slot_false.valid?
  end

  test "notes is optional" do
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      notes: nil
    )
    assert slot.valid?
  end

  test "notes must be at most 2000 characters" do
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      notes: "x" * 2001
    )
    assert_not slot.valid?
    assert_includes slot.errors[:notes], "is too long (maximum is 2000 characters)"
  end

  test "staff_memo is optional" do
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      staff_memo: nil
    )
    assert slot.valid?
  end

  test "staff_memo must be at most 2000 characters" do
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      staff_memo: "x" * 2001
    )
    assert_not slot.valid?
    assert_includes slot.errors[:staff_memo], "is too long (maximum is 2000 characters)"
  end

  # --- Associations ---

  test "belongs to organization" do
    slot = TimeSlot.new(organization: @org)
    assert_equal @org, slot.organization
  end

  test "requires organization" do
    slot = TimeSlot.new(service: @service, start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    assert_not slot.valid?
    assert_includes slot.errors[:organization], "must exist"
  end

  test "belongs to service" do
    slot = TimeSlot.new(service: @service)
    assert_equal @service, slot.service
  end

  test "requires service" do
    slot = TimeSlot.new(organization: @org, start_time: 1.hour.from_now, end_time: 2.hours.from_now)
    assert_not slot.valid?
    assert_includes slot.errors[:service], "must exist"
  end

  test "staff_member is optional" do
    slot = TimeSlot.new(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      staff_member: nil
    )
    assert slot.valid?
  end

  # --- Tenant Isolation ---

  test "service must belong to same organization" do
    other_org = Organization.create!(name: "Other", email: "other@x.com")
    other_service = Service.create!(name: "Other Svc", organization: other_org)

    slot = TimeSlot.new(
      organization: @org, service: other_service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    assert_not slot.valid?
    assert_includes slot.errors[:service_id], "does not belong to your organization"
  end

  test "staff_member must belong to same organization when present" do
    other_org = Organization.create!(name: "Other", email: "other@x.com")
    other_member = StaffMember.create!(name: "Other Staff", organization: other_org)

    slot = TimeSlot.new(
      organization: @org, service: @service, staff_member: other_member,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    assert_not slot.valid?
    assert_includes slot.errors[:staff_member_id], "does not belong to your organization"
  end

  test "staff_member from same organization is valid" do
    member = StaffMember.create!(name: "Staff", organization: @org)
    slot = TimeSlot.new(
      organization: @org, service: @service, staff_member: member,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    assert slot.valid?
  end

  # --- Availability Scopes ---

  test "available_slots scope returns available and kept records" do
    available = TimeSlot.create!(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now,
      available: true
    )
    unavailable = TimeSlot.create!(
      organization: @org, service: @service,
      start_time: 3.hours.from_now, end_time: 4.hours.from_now,
      available: false
    )

    result = TimeSlot.available_slots
    assert_includes result, available
    assert_not_includes result, unavailable
  end

  test "for_service scope filters by service" do
    other_service = Service.create!(name: "Manicure", organization: @org)
    s1 = TimeSlot.create!(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    s2 = TimeSlot.create!(
      organization: @org, service: other_service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )

    assert_equal [s1], TimeSlot.for_service(@service.id).to_a
    assert_equal [s2], TimeSlot.for_service(other_service.id).to_a
  end

  test "for_staff_member scope filters by staff member" do
    member = StaffMember.create!(name: "Staff", organization: @org)
    s1 = TimeSlot.create!(
      organization: @org, service: @service, staff_member: member,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    s2 = TimeSlot.create!(
      organization: @org, service: @service, staff_member: nil,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )

    assert_equal [s1], TimeSlot.for_staff_member(member.id).to_a
  end

  # --- Soft Deletes ---

  test "discard soft-deletes the record" do
    slot = TimeSlot.create!(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    slot.discard
    assert_not_nil slot.discarded_at
    assert_not_includes TimeSlot.kept, slot
  end

  test "kept scope excludes discarded records" do
    active = TimeSlot.create!(
      organization: @org, service: @service,
      start_time: 1.hour.from_now, end_time: 2.hours.from_now
    )
    discarded = TimeSlot.create!(
      organization: @org, service: @service,
      start_time: 3.hours.from_now, end_time: 4.hours.from_now
    )
    discarded.discard

    assert_includes TimeSlot.kept, active
    assert_not_includes TimeSlot.kept, discarded
  end
end
