require "test_helper"

class StaffMemberTest < ActiveSupport::TestCase
  # --- Validations ---

  test "valid staff member with required attributes" do
    member = StaffMember.new(
      name: "Jane Doe",
      organization: @org,
      role: "stylist",
      active: true
    )
    assert member.valid?
  end

  test "requires name" do
    member = StaffMember.new(organization: @org)
    assert_not member.valid?
    assert_includes member.errors[:name], "can't be blank"
  end

  test "name must be at most 255 characters" do
    member = StaffMember.new(name: "x" * 256, organization: @org)
    assert_not member.valid?
    assert_includes member.errors[:name], "is too long (maximum is 255 characters)"
  end

  test "role is optional" do
    member = StaffMember.new(name: "Staff", organization: @org, role: nil)
    assert member.valid?
  end

  test "role must be at most 255 characters" do
    member = StaffMember.new(name: "Staff", organization: @org, role: "x" * 256)
    assert_not member.valid?
    assert_includes member.errors[:role], "is too long (maximum is 255 characters)"
  end

  test "email is optional" do
    member = StaffMember.new(name: "Staff", organization: @org, email: nil)
    assert member.valid?
  end

  test "email must be at most 255 characters" do
    member = StaffMember.new(name: "Staff", organization: @org, email: "x" * 256)
    assert_not member.valid?
    assert_includes member.errors[:email], "is too long (maximum is 255 characters)"
  end

  test "phone is optional" do
    member = StaffMember.new(name: "Staff", organization: @org, phone: nil)
    assert member.valid?
  end

  test "phone must be at most 50 characters" do
    member = StaffMember.new(name: "Staff", organization: @org, phone: "x" * 51)
    assert_not member.valid?
    assert_includes member.errors[:phone], "is too long (maximum is 50 characters)"
  end

  test "active defaults to true" do
    member = StaffMember.new(name: "Staff", organization: @org)
    assert_equal true, member.active
  end

  test "active must be boolean-like" do
    member_active = StaffMember.new(name: "Staff", organization: @org, active: true)
    assert member_active.valid?
    member_inactive = StaffMember.new(name: "Staff", organization: @org, active: false)
    assert member_inactive.valid?
  end

  # --- Associations ---

  test "belongs to organization" do
    member = StaffMember.new(name: "Staff", organization: @org)
    assert_equal @org, member.organization
  end

  test "requires organization" do
    member = StaffMember.new(name: "Staff")
    assert_not member.valid?
    assert_includes member.errors[:organization], "must exist"
  end

  # --- Tenant Isolation ---

  test "organization must be a valid organization" do
    org = Organization.create!(name: "Valid Org", email: "valid@org.com")
    member = StaffMember.new(name: "Staff", organization_id: org.id)
    assert member.valid?
  end

  test "rejects invalid organization_id" do
    member = StaffMember.new(name: "Staff", organization_id: -999)
    assert_not member.valid?
    assert_includes member.errors[:organization_id], "is invalid"
  end

  test "for_organization scope filters by organization" do
    org1 = Organization.create!(name: "Org 1", email: "o1@x.com")
    org2 = Organization.create!(name: "Org 2", email: "o2@x.com")
    StaffMember.create!(name: "A", organization: org1, active: true)
    StaffMember.create!(name: "B", organization: org2, active: true)

    assert_equal 1, StaffMember.where(organization: org1).count
    assert_equal 1, StaffMember.where(organization: org2).count
  end

  # --- Soft Deletes ---

  test "discard soft-deletes the record" do
    member = StaffMember.create!(name: "Discardable", organization: @org)
    member.discard
    assert_not_nil member.discarded_at
    assert_not_includes StaffMember.kept, member
  end

  test "kept scope excludes discarded records" do
    active = StaffMember.create!(name: "Active", organization: @org)
    discarded = StaffMember.create!(name: "Gone", organization: @org)
    discarded.discard

    assert_includes StaffMember.kept, active
    assert_not_includes StaffMember.kept, discarded
  end

  # --- Active Staff Scope ---

  test "active_staff scope returns active and kept records" do
    active = StaffMember.create!(name: "Active", organization: @org, active: true)
    inactive = StaffMember.create!(name: "Inactive", organization: @org, active: false)
    discarded = StaffMember.create!(name: "Gone", organization: @org, active: true)
    discarded.discard

    result = StaffMember.active_staff
    assert_includes result, active
    assert_not_includes result, inactive
    assert_not_includes result, discarded
  end
end
