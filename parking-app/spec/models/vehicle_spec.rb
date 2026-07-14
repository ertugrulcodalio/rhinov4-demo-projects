# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Vehicle — CRUD & Permissions', type: :request do
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
      let(:user) { create_user_with_role('admin', org, ['vehicles.index', 'vehicles.show', 'vehicles.store', 'vehicles.update', 'vehicles.destroy']) }
      let(:record) { create(:vehicle, organization: org) }

      it 'can list vehicles' do
        get "/api/#{org.slug}/vehicles", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show vehicles' do
        get "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create vehicles' do
        post "/api/#{org.slug}/vehicles", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update vehicles' do
        put "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete vehicles' do
        delete "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as manager' do
      let(:user) { create_user_with_role('manager', org, ['vehicles.index', 'vehicles.show']) }
      let(:record) { create(:vehicle, organization: org) }

      it 'can list vehicles' do
        get "/api/#{org.slug}/vehicles", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show vehicles' do
        get "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create vehicles' do
        post "/api/#{org.slug}/vehicles", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot update vehicles' do
        put "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete vehicles' do
        delete "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

    context 'as member' do
      let(:user) { create_user_with_role('member', org, ['vehicles.index', 'vehicles.show', 'vehicles.store', 'vehicles.update']) }
      let(:record) { create(:vehicle, organization: org) }

      it 'can list vehicles' do
        get "/api/#{org.slug}/vehicles", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show vehicles' do
        get "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create vehicles' do
        post "/api/#{org.slug}/vehicles", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update vehicles' do
        put "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot delete vehicles' do
        delete "/api/#{org.slug}/vehicles/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

end
