require "test_helper"

class Api::ServicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @org = organizations(:one)
    @active_service = @org.services.create!(name: "Active Service", active: true, draft: false)
    @inactive_service = @org.services.create!(name: "Closed", active: false, draft: false)
    @draft_service = @org.services.create!(name: "Draft", active: true, draft: true)
    @discarded_service = @org.services.create!(name: "Discarded", active: true, draft: false)
    @discarded_service.discard
    
    @other_org = Organization.create!(name: "Other Org", email: "other@test.com", slug: "other-org")
    @other_service = @other_org.services.create!(name: "Other Service", active: true, draft: false)
  end

  test "index returns only active, non-draft, non-discarded services for organization" do
    get "/api/#{@org.slug}/services"
    
    assert_response :success
    json = JSON.parse(response.body)
    # Should include the fixture service and @active_service
    assert json.length >= 2
    assert_includes json.map { |s| s["id"] }, @active_service.id
    # Should NOT include inactive, draft, or discarded
    assert_not_includes json.map { |s| s["id"] }, @inactive_service.id
    assert_not_includes json.map { |s| s["id"] }, @draft_service.id
    assert_not_includes json.map { |s| s["id"] }, @discarded_service.id
  end

  test "index does not return inactive services" do
    get "/api/#{@org.slug}/services"
    
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_not_includes ids, @inactive_service.id
  end

  test "index does not return draft services" do
    get "/api/#{@org.slug}/services"
    
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_not_includes ids, @draft_service.id
  end

  test "index does not return discarded services" do
    get "/api/#{@org.slug}/services"
    
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_not_includes ids, @discarded_service.id
  end

  test "index does not return services from other organizations" do
    get "/api/#{@org.slug}/services"
    
    json = JSON.parse(response.body)
    ids = json.map { |s| s["id"] }
    assert_not_includes ids, @other_service.id
  end

  test "show returns active service from same organization" do
    get "/api/#{@org.slug}/services/#{@active_service.id}"
    
    assert_response :success
    json = JSON.parse(response.body)
    assert_equal @active_service.id, json["id"]
  end

  test "show returns 404 for service from other organization" do
    get "/api/#{@org.slug}/services/#{@other_service.id}"
    
    assert_response :not_found
  end

  test "show returns 404 for inactive service" do
    get "/api/#{@org.slug}/services/#{@inactive_service.id}"
    
    assert_response :not_found
  end

  test "show returns 404 for draft service" do
    get "/api/#{@org.slug}/services/#{@draft_service.id}"
    
    assert_response :not_found
  end

  test "show returns 404 for discarded service" do
    get "/api/#{@org.slug}/services/#{@discarded_service.id}"
    
    assert_response :not_found
  end
end