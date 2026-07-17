Source locally installed gems is ignoring #<Bundler::StubSpecification name=unf_ext version=0.0.7.7 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=nkf version=0.2.0 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=json version=2.5.1 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=ffi version=1.16.3 platform=ruby> because it is missing extensions
Source locally installed gems is ignoring #<Bundler::StubSpecification name=digest-crc version=0.6.3 platform=ruby> because it is missing extensions

Blog — CRUD & Permissions
  as admin
    can list blogs (FAILED - 1)
    can show blogs (FAILED - 2)
    can create blogs
    can update blogs (FAILED - 3)
    can delete blogs (FAILED - 4)
  as user
    can list blogs (FAILED - 5)
    can show blogs (FAILED - 6)
    cannot create blogs (FAILED - 7)
    cannot update blogs (FAILED - 8)
    cannot delete blogs (FAILED - 9)

Booking — CRUD & Permissions
  as owner
    can list bookings
    can show bookings (FAILED - 10)
    can create bookings
    can update bookings (FAILED - 11)
    can delete bookings (FAILED - 12)
  as admin
    can list bookings
    can show bookings (FAILED - 13)
    can update bookings (FAILED - 14)
    can delete bookings (FAILED - 15)
    cannot create bookings
  as staff
    can list bookings
    can show bookings (FAILED - 16)
    can update bookings (FAILED - 17)
    cannot create bookings
    cannot delete bookings (FAILED - 18)
  as customer
    can list bookings
    can show bookings (FAILED - 19)
    can create bookings
    can update bookings (FAILED - 20)
    can delete bookings (FAILED - 21)
    returns 403 when setting restricted fields

Service — CRUD & Permissions
  as owner
    can list services
    can show services (FAILED - 22)
    can create services
    can update services (FAILED - 23)
    can delete services (FAILED - 24)
  as admin
    can list services
    can show services (FAILED - 25)
    can create services
    can update services (FAILED - 26)
    can delete services (FAILED - 27)
  as staff
    can list services
    can show services (FAILED - 28)
    can create services
    can update services (FAILED - 29)
    cannot delete services (FAILED - 30)
  as customer
    can list services
    can show services (FAILED - 31)
    cannot create services
    cannot update services (FAILED - 32)
    cannot delete services (FAILED - 33)
    shows only permitted fields (FAILED - 34)

StaffMember — CRUD & Permissions
  as owner
    can list staff_members (FAILED - 35)
    can show staff_members (FAILED - 36)
    can create staff_members (FAILED - 37)
    can update staff_members (FAILED - 38)
    can delete staff_members (FAILED - 39)
  as admin
    can list staff_members (FAILED - 40)
    can show staff_members (FAILED - 41)
    can create staff_members (FAILED - 42)
    can update staff_members (FAILED - 43)
    can delete staff_members (FAILED - 44)
  as staff
    can list staff_members (FAILED - 45)
    can show staff_members (FAILED - 46)
    cannot create staff_members
    cannot update staff_members (FAILED - 47)
    cannot delete staff_members (FAILED - 48)
  as customer
    cannot list staff_members
    cannot show staff_members (FAILED - 49)
    cannot create staff_members
    cannot update staff_members (FAILED - 50)
    cannot delete staff_members (FAILED - 51)

TimeSlot — CRUD & Permissions
  as owner
    can list time_slots
    can show time_slots (FAILED - 52)
    can create time_slots
    can update time_slots (FAILED - 53)
    can delete time_slots (FAILED - 54)
  as admin
    can list time_slots
    can show time_slots (FAILED - 55)
    can create time_slots
    can update time_slots (FAILED - 56)
    can delete time_slots (FAILED - 57)
  as staff
    can list time_slots
    can show time_slots (FAILED - 58)
    can create time_slots
    can update time_slots (FAILED - 59)
    cannot delete time_slots (FAILED - 60)
  as customer
    can list time_slots
    can show time_slots (FAILED - 61)
    cannot create time_slots
    cannot update time_slots (FAILED - 62)
    cannot delete time_slots (FAILED - 63)
    shows only permitted fields (FAILED - 64)

Auth
  logs in with valid credentials and returns token
  rejects login with invalid credentials
  rejects login with non-existent email
  requires authentication to access protected endpoints
  can logout

Comments
  admin can create a comment (FAILED - 65)
  auto-sets user_id on comment creation (FAILED - 66)
  comment has a uuid (FAILED - 67)
  admin can list comments (FAILED - 68)
  member can create a comment (FAILED - 69)
  viewer cannot create a comment (FAILED - 70)

Labels
  admin can create a label (FAILED - 71)
  admin can list labels (FAILED - 72)
  admin can update a label (FAILED - 73)
  admin can soft-delete a label (FAILED - 74)
  force-delete route does not exist for labels (FAILED - 75)
  member cannot create a label (FAILED - 76)
  viewer can list labels (FAILED - 77)
  labels are isolated per organization (FAILED - 78)

Projects
  admin can list projects (FAILED - 79)
  admin can create a project (FAILED - 80)
  admin can update a project (FAILED - 81)
  admin can delete a project (FAILED - 82)
  admin sees all fields including budget and internal_notes (FAILED - 83)
  member cannot see budget or internal_notes (FAILED - 84)
  viewer cannot see budget or internal_notes (FAILED - 85)
  manager cannot set budget when creating a project (FAILED - 86)
  member cannot create a project (FAILED - 87)
  viewer cannot delete a project (FAILED - 88)
  cannot access projects from another organization (FAILED - 89)
  cannot access another organization endpoint

Soft Deletes
  admin can view trashed projects (FAILED - 90)
  admin can restore a soft-deleted project (FAILED - 91)
  admin can force-delete a project (FAILED - 92)
  viewer cannot restore a project (FAILED - 93)

Tasks
  admin can create a task (FAILED - 94)
  admin can list tasks (FAILED - 95)
  admin can update a task (FAILED - 96)
  admin can delete a task (FAILED - 97)
  member only sees tasks assigned to them (FAILED - 98)
  admin sees estimated_hours (FAILED - 99)
  member cannot see estimated_hours (FAILED - 100)
  member can update task status and description (FAILED - 101)
  member cannot update task title (forbidden field) (FAILED - 102)
  member cannot create a task (FAILED - 103)
  viewer cannot update a task (FAILED - 104)

Failures:

  1) Blog — CRUD & Permissions as admin can list blogs
     Failure/Error: expect(response).to have_http_status(:ok)
       expected the response to have status code :ok (200) but it was :not_found (404)
     # ./spec/models/blog_spec.rb:31:in 'block (3 levels) in <top (required)>'

  2) Blog — CRUD & Permissions as admin can show blogs
     Failure/Error: let(:record) { create(:blog, organization: org) }

     NameError:
       uninitialized constant Blog
     # ./spec/models/blog_spec.rb:27:in 'block (3 levels) in <top (required)>'
     # ./spec/models/blog_spec.rb:35:in 'block (3 levels) in <top (required)>'

  3) Blog — CRUD & Permissions as admin can update blogs
     Failure/Error: let(:record) { create(:blog, organization: org) }

     NameError:
       uninitialized constant Blog
     # ./spec/models/blog_spec.rb:27:in 'block (3 levels) in <top (required)>'
     # ./spec/models/blog_spec.rb:45:in 'block (3 levels) in <top (required)>'

  4) Blog — CRUD & Permissions as admin can delete blogs
     Failure/Error: let(:record) { create(:blog, organization: org) }

     NameError:
       uninitialized constant Blog
     # ./spec/models/blog_spec.rb:27:in 'block (3 levels) in <top (required)>'
     # ./spec/models/blog_spec.rb:50:in 'block (3 levels) in <top (required)>'

  5) Blog — CRUD & Permissions as user can list blogs
     Failure/Error: expect(response).to have_http_status(:ok)
       expected the response to have status code :ok (200) but it was :not_found (404)
     # ./spec/models/blog_spec.rb:62:in 'block (3 levels) in <top (required)>'

  6) Blog — CRUD & Permissions as user can show blogs
     Failure/Error: let(:record) { create(:blog, organization: org) }

     NameError:
       uninitialized constant Blog
     # ./spec/models/blog_spec.rb:58:in 'block (3 levels) in <top (required)>'
     # ./spec/models/blog_spec.rb:66:in 'block (3 levels) in <top (required)>'

  7) Blog — CRUD & Permissions as user cannot create blogs
     Failure/Error: expect(response).to have_http_status(:forbidden)
       expected the response to have status code :forbidden (403) but it was :not_found (404)
     # ./spec/models/blog_spec.rb:72:in 'block (3 levels) in <top (required)>'

  8) Blog — CRUD & Permissions as user cannot update blogs
     Failure/Error: let(:record) { create(:blog, organization: org) }

     NameError:
       uninitialized constant Blog
     # ./spec/models/blog_spec.rb:58:in 'block (3 levels) in <top (required)>'
     # ./spec/models/blog_spec.rb:76:in 'block (3 levels) in <top (required)>'

  9) Blog — CRUD & Permissions as user cannot delete blogs
     Failure/Error: let(:record) { create(:blog, organization: org) }

     NameError:
       uninitialized constant Blog
     # ./spec/models/blog_spec.rb:58:in 'block (3 levels) in <top (required)>'
     # ./spec/models/blog_spec.rb:81:in 'block (3 levels) in <top (required)>'

  10) Booking — CRUD & Permissions as owner can show bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:35:in 'block (3 levels) in <main>'

  11) Booking — CRUD & Permissions as owner can update bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:45:in 'block (3 levels) in <main>'

  12) Booking — CRUD & Permissions as owner can delete bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:50:in 'block (3 levels) in <main>'

  13) Booking — CRUD & Permissions as admin can show bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:66:in 'block (3 levels) in <main>'

  14) Booking — CRUD & Permissions as admin can update bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:71:in 'block (3 levels) in <main>'

  15) Booking — CRUD & Permissions as admin can delete bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:76:in 'block (3 levels) in <main>'

  16) Booking — CRUD & Permissions as staff can show bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:97:in 'block (3 levels) in <main>'

  17) Booking — CRUD & Permissions as staff can update bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:102:in 'block (3 levels) in <main>'

  18) Booking — CRUD & Permissions as staff cannot delete bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:112:in 'block (3 levels) in <main>'

  19) Booking — CRUD & Permissions as customer can show bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:128:in 'block (3 levels) in <main>'

  20) Booking — CRUD & Permissions as customer can update bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:138:in 'block (3 levels) in <main>'

  21) Booking — CRUD & Permissions as customer can delete bookings
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/booking_spec.rb:143:in 'block (3 levels) in <main>'

  22) Service — CRUD & Permissions as owner can show services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:35:in 'block (3 levels) in <main>'

  23) Service — CRUD & Permissions as owner can update services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:45:in 'block (3 levels) in <main>'

  24) Service — CRUD & Permissions as owner can delete services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:50:in 'block (3 levels) in <main>'

  25) Service — CRUD & Permissions as admin can show services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:66:in 'block (3 levels) in <main>'

  26) Service — CRUD & Permissions as admin can update services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:76:in 'block (3 levels) in <main>'

  27) Service — CRUD & Permissions as admin can delete services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:81:in 'block (3 levels) in <main>'

  28) Service — CRUD & Permissions as staff can show services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:97:in 'block (3 levels) in <main>'

  29) Service — CRUD & Permissions as staff can update services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:107:in 'block (3 levels) in <main>'

  30) Service — CRUD & Permissions as staff cannot delete services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:112:in 'block (3 levels) in <main>'

  31) Service — CRUD & Permissions as customer can show services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:128:in 'block (3 levels) in <main>'

  32) Service — CRUD & Permissions as customer cannot update services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:138:in 'block (3 levels) in <main>'

  33) Service — CRUD & Permissions as customer cannot delete services
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:143:in 'block (3 levels) in <main>'

  34) Service — CRUD & Permissions as customer shows only permitted fields
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/service_spec.rb:148:in 'block (3 levels) in <main>'

  35) StaffMember — CRUD & Permissions as owner can list staff_members
      Failure/Error: get "/api/#{org.slug}/staff_members", headers: auth_headers(user)

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:30:in 'block (3 levels) in <main>'

  36) StaffMember — CRUD & Permissions as owner can show staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:35:in 'block (3 levels) in <main>'

  37) StaffMember — CRUD & Permissions as owner can create staff_members
      Failure/Error: post "/api/#{org.slug}/staff_members", headers: auth_headers(user)

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:40:in 'block (3 levels) in <main>'

  38) StaffMember — CRUD & Permissions as owner can update staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:45:in 'block (3 levels) in <main>'

  39) StaffMember — CRUD & Permissions as owner can delete staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:50:in 'block (3 levels) in <main>'

  40) StaffMember — CRUD & Permissions as admin can list staff_members
      Failure/Error: get "/api/#{org.slug}/staff_members", headers: auth_headers(user)

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:61:in 'block (3 levels) in <main>'

  41) StaffMember — CRUD & Permissions as admin can show staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:66:in 'block (3 levels) in <main>'

  42) StaffMember — CRUD & Permissions as admin can create staff_members
      Failure/Error: post "/api/#{org.slug}/staff_members", headers: auth_headers(user)

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:71:in 'block (3 levels) in <main>'

  43) StaffMember — CRUD & Permissions as admin can update staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:76:in 'block (3 levels) in <main>'

  44) StaffMember — CRUD & Permissions as admin can delete staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:81:in 'block (3 levels) in <main>'

  45) StaffMember — CRUD & Permissions as staff can list staff_members
      Failure/Error: get "/api/#{org.slug}/staff_members", headers: auth_headers(user)

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:92:in 'block (3 levels) in <main>'

  46) StaffMember — CRUD & Permissions as staff can show staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:97:in 'block (3 levels) in <main>'

  47) StaffMember — CRUD & Permissions as staff cannot update staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:107:in 'block (3 levels) in <main>'

  48) StaffMember — CRUD & Permissions as staff cannot delete staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:112:in 'block (3 levels) in <main>'

  49) StaffMember — CRUD & Permissions as customer cannot show staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:128:in 'block (3 levels) in <main>'

  50) StaffMember — CRUD & Permissions as customer cannot update staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:138:in 'block (3 levels) in <main>'

  51) StaffMember — CRUD & Permissions as customer cannot delete staff_members
      Failure/Error: let(:record) { create(:staff_member, organization: org) }

      NotImplementedError:
        Scopes::StaffMemberScope must implement #apply(relation)
      # ./spec/models/staff_member_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/staff_member_spec.rb:143:in 'block (3 levels) in <main>'

  52) TimeSlot — CRUD & Permissions as owner can show time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:35:in 'block (3 levels) in <main>'

  53) TimeSlot — CRUD & Permissions as owner can update time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:45:in 'block (3 levels) in <main>'

  54) TimeSlot — CRUD & Permissions as owner can delete time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:27:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:50:in 'block (3 levels) in <main>'

  55) TimeSlot — CRUD & Permissions as admin can show time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:66:in 'block (3 levels) in <main>'

  56) TimeSlot — CRUD & Permissions as admin can update time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:76:in 'block (3 levels) in <main>'

  57) TimeSlot — CRUD & Permissions as admin can delete time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:58:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:81:in 'block (3 levels) in <main>'

  58) TimeSlot — CRUD & Permissions as staff can show time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:97:in 'block (3 levels) in <main>'

  59) TimeSlot — CRUD & Permissions as staff can update time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:107:in 'block (3 levels) in <main>'

  60) TimeSlot — CRUD & Permissions as staff cannot delete time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:89:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:112:in 'block (3 levels) in <main>'

  61) TimeSlot — CRUD & Permissions as customer can show time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:128:in 'block (3 levels) in <main>'

  62) TimeSlot — CRUD & Permissions as customer cannot update time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:138:in 'block (3 levels) in <main>'

  63) TimeSlot — CRUD & Permissions as customer cannot delete time_slots
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:143:in 'block (3 levels) in <main>'

  64) TimeSlot — CRUD & Permissions as customer shows only permitted fields
      Failure/Error: name { Faker::Name.name }

      NameError:
        uninitialized constant Faker
      # ./spec/factories/services.rb:5:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:120:in 'block (3 levels) in <main>'
      # ./spec/models/time_slot_spec.rb:148:in 'block (3 levels) in <main>'

  65) Comments admin can create a comment
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/comment_spec.rb:9:in 'block (2 levels) in <main>'

  66) Comments auto-sets user_id on comment creation
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/comment_spec.rb:9:in 'block (2 levels) in <main>'

  67) Comments comment has a uuid
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/comment_spec.rb:9:in 'block (2 levels) in <main>'

  68) Comments admin can list comments
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/comment_spec.rb:9:in 'block (2 levels) in <main>'

  69) Comments member can create a comment
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/comment_spec.rb:9:in 'block (2 levels) in <main>'

  70) Comments viewer cannot create a comment
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/comment_spec.rb:9:in 'block (2 levels) in <main>'

  71) Labels admin can create a label
      Failure/Error: expect(response).to have_http_status(:created)
        expected the response to have status code :created (201) but it was :not_found (404)
      # ./spec/requests/label_spec.rb:23:in 'block (2 levels) in <main>'

  72) Labels admin can list labels
      Failure/Error: create(:label, organization_id: @org.id)

      NameError:
        uninitialized constant Label
      # ./spec/requests/label_spec.rb:31:in 'block (2 levels) in <main>'

  73) Labels admin can update a label
      Failure/Error: label = create(:label, organization_id: @org.id)

      NameError:
        uninitialized constant Label
      # ./spec/requests/label_spec.rb:43:in 'block (2 levels) in <main>'

  74) Labels admin can soft-delete a label
      Failure/Error: label = create(:label, organization_id: @org.id)

      NameError:
        uninitialized constant Label
      # ./spec/requests/label_spec.rb:56:in 'block (2 levels) in <main>'

  75) Labels force-delete route does not exist for labels
      Failure/Error: label = create(:label, organization_id: @org.id)

      NameError:
        uninitialized constant Label
      # ./spec/requests/label_spec.rb:71:in 'block (2 levels) in <main>'

  76) Labels member cannot create a label
      Failure/Error: expect(response).to have_http_status(:forbidden)
        expected the response to have status code :forbidden (403) but it was :not_found (404)
      # ./spec/requests/label_spec.rb:88:in 'block (2 levels) in <main>'

  77) Labels viewer can list labels
      Failure/Error: create(:label, organization_id: @org.id)

      NameError:
        uninitialized constant Label
      # ./spec/requests/label_spec.rb:93:in 'block (2 levels) in <main>'

  78) Labels labels are isolated per organization
      Failure/Error: create(:label, organization_id: @org.id, name: "mine")

      NameError:
        uninitialized constant Label
      # ./spec/requests/label_spec.rb:108:in 'block (2 levels) in <main>'

  79) Projects admin can list projects
      Failure/Error: create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:17:in 'block (2 levels) in <main>'

  80) Projects admin can create a project
      Failure/Error: expect(response).to have_http_status(:created)
        expected the response to have status code :created (201) but it was :not_found (404)
      # ./spec/requests/project_spec.rb:40:in 'block (2 levels) in <main>'

  81) Projects admin can update a project
      Failure/Error: project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:48:in 'block (2 levels) in <main>'

  82) Projects admin can delete a project
      Failure/Error: project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:62:in 'block (2 levels) in <main>'

  83) Projects admin sees all fields including budget and internal_notes
      Failure/Error: project = create(:project, organization_id: @org.id, budget: 50_000, internal_notes: "Top secret")

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:77:in 'block (2 levels) in <main>'

  84) Projects member cannot see budget or internal_notes
      Failure/Error: project = create(:project, organization_id: @org.id, budget: 50_000, internal_notes: "Top secret")

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:89:in 'block (2 levels) in <main>'

  85) Projects viewer cannot see budget or internal_notes
      Failure/Error: project = create(:project, organization_id: @org.id, budget: 50_000, internal_notes: "Top secret")

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:102:in 'block (2 levels) in <main>'

  86) Projects manager cannot set budget when creating a project
      Failure/Error: expect(response).to have_http_status(:forbidden)
        expected the response to have status code :forbidden (403) but it was :not_found (404)
      # ./spec/requests/project_spec.rb:125:in 'block (2 levels) in <main>'

  87) Projects member cannot create a project
      Failure/Error: expect(response).to have_http_status(:forbidden)
        expected the response to have status code :forbidden (403) but it was :not_found (404)
      # ./spec/requests/project_spec.rb:137:in 'block (2 levels) in <main>'

  88) Projects viewer cannot delete a project
      Failure/Error: project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:142:in 'block (2 levels) in <main>'

  89) Projects cannot access projects from another organization
      Failure/Error: project = create(:project, organization_id: other_org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/project_spec.rb:156:in 'block (2 levels) in <main>'

  90) Soft Deletes admin can view trashed projects
      Failure/Error: project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/soft_delete_spec.rb:13:in 'block (2 levels) in <main>'

  91) Soft Deletes admin can restore a soft-deleted project
      Failure/Error: project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/soft_delete_spec.rb:26:in 'block (2 levels) in <main>'

  92) Soft Deletes admin can force-delete a project
      Failure/Error: project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/soft_delete_spec.rb:37:in 'block (2 levels) in <main>'

  93) Soft Deletes viewer cannot restore a project
      Failure/Error: project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/soft_delete_spec.rb:48:in 'block (2 levels) in <main>'

  94) Tasks admin can create a task
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  95) Tasks admin can list tasks
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  96) Tasks admin can update a task
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  97) Tasks admin can delete a task
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  98) Tasks member only sees tasks assigned to them
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  99) Tasks admin sees estimated_hours
      Failure/Error: @project = create(:project, organization_id: @org.id)

      NameError:
        uninitialized constant Project
      # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  100) Tasks member cannot see estimated_hours
       Failure/Error: @project = create(:project, organization_id: @org.id)

       NameError:
         uninitialized constant Project
       # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  101) Tasks member can update task status and description
       Failure/Error: @project = create(:project, organization_id: @org.id)

       NameError:
         uninitialized constant Project
       # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  102) Tasks member cannot update task title (forbidden field)
       Failure/Error: @project = create(:project, organization_id: @org.id)

       NameError:
         uninitialized constant Project
       # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  103) Tasks member cannot create a task
       Failure/Error: @project = create(:project, organization_id: @org.id)

       NameError:
         uninitialized constant Project
       # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

  104) Tasks viewer cannot update a task
       Failure/Error: @project = create(:project, organization_id: @org.id)

       NameError:
         uninitialized constant Project
       # ./spec/requests/task_spec.rb:9:in 'block (2 levels) in <main>'

Finished in 1.04 seconds (files took 0.89522 seconds to load)
139 examples, 104 failures

Failed examples:

rspec ./spec/models/blog_spec.rb:29 # Blog — CRUD & Permissions as admin can list blogs
rspec ./spec/models/blog_spec.rb:34 # Blog — CRUD & Permissions as admin can show blogs
rspec ./spec/models/blog_spec.rb:44 # Blog — CRUD & Permissions as admin can update blogs
rspec ./spec/models/blog_spec.rb:49 # Blog — CRUD & Permissions as admin can delete blogs
rspec ./spec/models/blog_spec.rb:60 # Blog — CRUD & Permissions as user can list blogs
rspec ./spec/models/blog_spec.rb:65 # Blog — CRUD & Permissions as user can show blogs
rspec ./spec/models/blog_spec.rb:70 # Blog — CRUD & Permissions as user cannot create blogs
rspec ./spec/models/blog_spec.rb:75 # Blog — CRUD & Permissions as user cannot update blogs
rspec ./spec/models/blog_spec.rb:80 # Blog — CRUD & Permissions as user cannot delete blogs
rspec ./spec/models/booking_spec.rb:34 # Booking — CRUD & Permissions as owner can show bookings
rspec ./spec/models/booking_spec.rb:44 # Booking — CRUD & Permissions as owner can update bookings
rspec ./spec/models/booking_spec.rb:49 # Booking — CRUD & Permissions as owner can delete bookings
rspec ./spec/models/booking_spec.rb:65 # Booking — CRUD & Permissions as admin can show bookings
rspec ./spec/models/booking_spec.rb:70 # Booking — CRUD & Permissions as admin can update bookings
rspec ./spec/models/booking_spec.rb:75 # Booking — CRUD & Permissions as admin can delete bookings
rspec ./spec/models/booking_spec.rb:96 # Booking — CRUD & Permissions as staff can show bookings
rspec ./spec/models/booking_spec.rb:101 # Booking — CRUD & Permissions as staff can update bookings
rspec ./spec/models/booking_spec.rb:111 # Booking — CRUD & Permissions as staff cannot delete bookings
rspec ./spec/models/booking_spec.rb:127 # Booking — CRUD & Permissions as customer can show bookings
rspec ./spec/models/booking_spec.rb:137 # Booking — CRUD & Permissions as customer can update bookings
rspec ./spec/models/booking_spec.rb:142 # Booking — CRUD & Permissions as customer can delete bookings
rspec ./spec/models/service_spec.rb:34 # Service — CRUD & Permissions as owner can show services
rspec ./spec/models/service_spec.rb:44 # Service — CRUD & Permissions as owner can update services
rspec ./spec/models/service_spec.rb:49 # Service — CRUD & Permissions as owner can delete services
rspec ./spec/models/service_spec.rb:65 # Service — CRUD & Permissions as admin can show services
rspec ./spec/models/service_spec.rb:75 # Service — CRUD & Permissions as admin can update services
rspec ./spec/models/service_spec.rb:80 # Service — CRUD & Permissions as admin can delete services
rspec ./spec/models/service_spec.rb:96 # Service — CRUD & Permissions as staff can show services
rspec ./spec/models/service_spec.rb:106 # Service — CRUD & Permissions as staff can update services
rspec ./spec/models/service_spec.rb:111 # Service — CRUD & Permissions as staff cannot delete services
rspec ./spec/models/service_spec.rb:127 # Service — CRUD & Permissions as customer can show services
rspec ./spec/models/service_spec.rb:137 # Service — CRUD & Permissions as customer cannot update services
rspec ./spec/models/service_spec.rb:142 # Service — CRUD & Permissions as customer cannot delete services
rspec ./spec/models/service_spec.rb:147 # Service — CRUD & Permissions as customer shows only permitted fields
rspec ./spec/models/staff_member_spec.rb:29 # StaffMember — CRUD & Permissions as owner can list staff_members
rspec ./spec/models/staff_member_spec.rb:34 # StaffMember — CRUD & Permissions as owner can show staff_members
rspec ./spec/models/staff_member_spec.rb:39 # StaffMember — CRUD & Permissions as owner can create staff_members
rspec ./spec/models/staff_member_spec.rb:44 # StaffMember — CRUD & Permissions as owner can update staff_members
rspec ./spec/models/staff_member_spec.rb:49 # StaffMember — CRUD & Permissions as owner can delete staff_members
rspec ./spec/models/staff_member_spec.rb:60 # StaffMember — CRUD & Permissions as admin can list staff_members
rspec ./spec/models/staff_member_spec.rb:65 # StaffMember — CRUD & Permissions as admin can show staff_members
rspec ./spec/models/staff_member_spec.rb:70 # StaffMember — CRUD & Permissions as admin can create staff_members
rspec ./spec/models/staff_member_spec.rb:75 # StaffMember — CRUD & Permissions as admin can update staff_members
rspec ./spec/models/staff_member_spec.rb:80 # StaffMember — CRUD & Permissions as admin can delete staff_members
rspec ./spec/models/staff_member_spec.rb:91 # StaffMember — CRUD & Permissions as staff can list staff_members
rspec ./spec/models/staff_member_spec.rb:96 # StaffMember — CRUD & Permissions as staff can show staff_members
rspec ./spec/models/staff_member_spec.rb:106 # StaffMember — CRUD & Permissions as staff cannot update staff_members
rspec ./spec/models/staff_member_spec.rb:111 # StaffMember — CRUD & Permissions as staff cannot delete staff_members
rspec ./spec/models/staff_member_spec.rb:127 # StaffMember — CRUD & Permissions as customer cannot show staff_members
rspec ./spec/models/staff_member_spec.rb:137 # StaffMember — CRUD & Permissions as customer cannot update staff_members
rspec ./spec/models/staff_member_spec.rb:142 # StaffMember — CRUD & Permissions as customer cannot delete staff_members
rspec ./spec/models/time_slot_spec.rb:34 # TimeSlot — CRUD & Permissions as owner can show time_slots
rspec ./spec/models/time_slot_spec.rb:44 # TimeSlot — CRUD & Permissions as owner can update time_slots
rspec ./spec/models/time_slot_spec.rb:49 # TimeSlot — CRUD & Permissions as owner can delete time_slots
rspec ./spec/models/time_slot_spec.rb:65 # TimeSlot — CRUD & Permissions as admin can show time_slots
rspec ./spec/models/time_slot_spec.rb:75 # TimeSlot — CRUD & Permissions as admin can update time_slots
rspec ./spec/models/time_slot_spec.rb:80 # TimeSlot — CRUD & Permissions as admin can delete time_slots
rspec ./spec/models/time_slot_spec.rb:96 # TimeSlot — CRUD & Permissions as staff can show time_slots
rspec ./spec/models/time_slot_spec.rb:106 # TimeSlot — CRUD & Permissions as staff can update time_slots
rspec ./spec/models/time_slot_spec.rb:111 # TimeSlot — CRUD & Permissions as staff cannot delete time_slots
rspec ./spec/models/time_slot_spec.rb:127 # TimeSlot — CRUD & Permissions as customer can show time_slots
rspec ./spec/models/time_slot_spec.rb:137 # TimeSlot — CRUD & Permissions as customer cannot update time_slots
rspec ./spec/models/time_slot_spec.rb:142 # TimeSlot — CRUD & Permissions as customer cannot delete time_slots
rspec ./spec/models/time_slot_spec.rb:147 # TimeSlot — CRUD & Permissions as customer shows only permitted fields
rspec ./spec/requests/comment_spec.rb:17 # Comments admin can create a comment
rspec ./spec/requests/comment_spec.rb:30 # Comments auto-sets user_id on comment creation
rspec ./spec/requests/comment_spec.rb:43 # Comments comment has a uuid
rspec ./spec/requests/comment_spec.rb:58 # Comments admin can list comments
rspec ./spec/requests/comment_spec.rb:67 # Comments member can create a comment
rspec ./spec/requests/comment_spec.rb:79 # Comments viewer cannot create a comment
rspec ./spec/requests/label_spec.rb:15 # Labels admin can create a label
rspec ./spec/requests/label_spec.rb:29 # Labels admin can list labels
rspec ./spec/requests/label_spec.rb:41 # Labels admin can update a label
rspec ./spec/requests/label_spec.rb:54 # Labels admin can soft-delete a label
rspec ./spec/requests/label_spec.rb:69 # Labels force-delete route does not exist for labels
rspec ./spec/requests/label_spec.rb:83 # Labels member cannot create a label
rspec ./spec/requests/label_spec.rb:91 # Labels viewer can list labels
rspec ./spec/requests/label_spec.rb:104 # Labels labels are isolated per organization
rspec ./spec/requests/project_spec.rb:15 # Projects admin can list projects
rspec ./spec/requests/project_spec.rb:27 # Projects admin can create a project
rspec ./spec/requests/project_spec.rb:46 # Projects admin can update a project
rspec ./spec/requests/project_spec.rb:60 # Projects admin can delete a project
rspec ./spec/requests/project_spec.rb:75 # Projects admin sees all fields including budget and internal_notes
rspec ./spec/requests/project_spec.rb:87 # Projects member cannot see budget or internal_notes
rspec ./spec/requests/project_spec.rb:100 # Projects viewer cannot see budget or internal_notes
rspec ./spec/requests/project_spec.rb:116 # Projects manager cannot set budget when creating a project
rspec ./spec/requests/project_spec.rb:132 # Projects member cannot create a project
rspec ./spec/requests/project_spec.rb:140 # Projects viewer cannot delete a project
rspec ./spec/requests/project_spec.rb:153 # Projects cannot access projects from another organization
rspec ./spec/requests/soft_delete_spec.rb:11 # Soft Deletes admin can view trashed projects
rspec ./spec/requests/soft_delete_spec.rb:24 # Soft Deletes admin can restore a soft-deleted project
rspec ./spec/requests/soft_delete_spec.rb:35 # Soft Deletes admin can force-delete a project
rspec ./spec/requests/soft_delete_spec.rb:46 # Soft Deletes viewer cannot restore a project
rspec ./spec/requests/task_spec.rb:16 # Tasks admin can create a task
rspec ./spec/requests/task_spec.rb:33 # Tasks admin can list tasks
rspec ./spec/requests/task_spec.rb:42 # Tasks admin can update a task
rspec ./spec/requests/task_spec.rb:58 # Tasks admin can delete a task
rspec ./spec/requests/task_spec.rb:71 # Tasks member only sees tasks assigned to them
rspec ./spec/requests/task_spec.rb:91 # Tasks admin sees estimated_hours
rspec ./spec/requests/task_spec.rb:102 # Tasks member cannot see estimated_hours
rspec ./spec/requests/task_spec.rb:117 # Tasks member can update task status and description
rspec ./spec/requests/task_spec.rb:132 # Tasks member cannot update task title (forbidden field)
rspec ./spec/requests/task_spec.rb:147 # Tasks member cannot create a task
rspec ./spec/requests/task_spec.rb:162 # Tasks viewer cannot update a task

