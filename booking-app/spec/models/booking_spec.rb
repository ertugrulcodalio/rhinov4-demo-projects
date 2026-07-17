# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Booking — CRUD & Permissions', type: :request do
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

    context 'as owner' do
      let(:user) { create_user_with_role('owner', org, ['bookings.index', 'bookings.show', 'bookings.store', 'bookings.update', 'bookings.destroy']) }
      let(:record) { create(:booking, organization: org) }

      it 'can list bookings' do
        get "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show bookings' do
        get "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create bookings' do
        post "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update bookings' do
        put "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete bookings' do
        delete "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as admin' do
      let(:user) { create_user_with_role('admin', org, ['bookings.index', 'bookings.show', 'bookings.update', 'bookings.destroy']) }
      let(:record) { create(:booking, organization: org) }

      it 'can list bookings' do
        get "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show bookings' do
        get "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can update bookings' do
        put "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete bookings' do
        delete "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

      it 'cannot create bookings' do
        post "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

    context 'as staff' do
      let(:user) { create_user_with_role('staff', org, ['bookings.index', 'bookings.show', 'bookings.update']) }
      let(:record) { create(:booking, organization: org) }

      it 'can list bookings' do
        get "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show bookings' do
        get "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can update bookings' do
        put "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create bookings' do
        post "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete bookings' do
        delete "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

    context 'as customer' do
      let(:user) { create_user_with_role('customer', org, ['bookings.index', 'bookings.show', 'bookings.store', 'bookings.update', 'bookings.destroy']) }
      let(:record) { create(:booking, organization: org) }

      it 'can list bookings' do
        get "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show bookings' do
        get "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create bookings' do
        post "/api/#{org.slug}/bookings", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update bookings' do
        put "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete bookings' do
        delete "/api/#{org.slug}/bookings/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

      it 'returns 403 when setting restricted fields' do
        post "/api/#{org.slug}/bookings",
          params: { user_id: 'forbidden_value' },
          headers: auth_headers(user)

        expect(response).to have_http_status(:forbidden)
      end

    end

end
