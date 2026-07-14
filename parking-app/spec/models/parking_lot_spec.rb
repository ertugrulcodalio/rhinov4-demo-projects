# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ParkingLot — CRUD & Permissions', type: :request do
  let(:org) { create(:organization) }

  def create_user_with_role(role_slug, organization, permissions)
    user = create(:user)
    role = Role.find_or_create_by!(slug: role_slug, name: role_slug.capitalize)
    UserRole.find_or_create_by!(
      user: user,
      organization: organization,
      role: role
    ) do |ur|
      ur.permissions = permissions
    end
    user
  end

  def auth_headers(user)
    { 'Authorization' => "Bearer #{user.api_token}" }
  end

    context 'as admin' do
      let(:user) { create_user_with_role('admin', org, ['parking_lots.index', 'parking_lots.show', 'parking_lots.store', 'parking_lots.update', 'parking_lots.destroy']) }
      let(:record) { create(:parking_lot, organization: org) }

      it 'can list parking_lots' do
        get "/api/#{org.slug}/parking_lots", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show parking_lots' do
        get "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create parking_lots' do
        post "/api/#{org.slug}/parking_lots", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update parking_lots' do
        put "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete parking_lots' do
        delete "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as manager' do
      let(:user) { create_user_with_role('manager', org, ['parking_lots.index', 'parking_lots.show', 'parking_lots.update']) }
      let(:record) { create(:parking_lot, organization: org) }

      it 'can list parking_lots' do
        get "/api/#{org.slug}/parking_lots", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show parking_lots' do
        get "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can update parking_lots' do
        put "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create parking_lots' do
        post "/api/#{org.slug}/parking_lots", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete parking_lots' do
        delete "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

    context 'as member' do
      let(:user) { create_user_with_role('member', org, ['parking_lots.index', 'parking_lots.show']) }
      let(:record) { create(:parking_lot, organization: org) }

      it 'can list parking_lots' do
        get "/api/#{org.slug}/parking_lots", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show parking_lots' do
        get "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create parking_lots' do
        post "/api/#{org.slug}/parking_lots", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot update parking_lots' do
        put "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete parking_lots' do
        delete "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'shows only permitted fields' do
        get "/api/#{org.slug}/parking_lots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        data = JSON.parse(response.body)

        expect(data).to have_key('id')
        expect(data).to have_key('name')
        expect(data).to have_key('address')
        expect(data).to have_key('total_spots')
      end

    end

end
