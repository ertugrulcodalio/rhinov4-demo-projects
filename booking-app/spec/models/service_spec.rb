# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Service — CRUD & Permissions', type: :request do
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
      let(:user) { create_user_with_role('owner', org, ['services.index', 'services.show', 'services.store', 'services.update', 'services.destroy']) }
      let(:record) { create(:service, organization: org) }

      it 'can list services' do
        get "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show services' do
        get "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create services' do
        post "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update services' do
        put "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete services' do
        delete "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as admin' do
      let(:user) { create_user_with_role('admin', org, ['services.index', 'services.show', 'services.store', 'services.update', 'services.destroy']) }
      let(:record) { create(:service, organization: org) }

      it 'can list services' do
        get "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show services' do
        get "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create services' do
        post "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update services' do
        put "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete services' do
        delete "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as staff' do
      let(:user) { create_user_with_role('staff', org, ['services.index', 'services.show', 'services.store', 'services.update']) }
      let(:record) { create(:service, organization: org) }

      it 'can list services' do
        get "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show services' do
        get "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create services' do
        post "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update services' do
        put "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot delete services' do
        delete "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

    context 'as customer' do
      let(:user) { create_user_with_role('customer', org, ['services.index', 'services.show']) }
      let(:record) { create(:service, organization: org) }

      it 'can list services' do
        get "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show services' do
        get "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create services' do
        post "/api/#{org.slug}/services", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot update services' do
        put "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete services' do
        delete "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'shows only permitted fields' do
        get "/api/#{org.slug}/services/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        data = JSON.parse(response.body)

        expect(data).to have_key('id')
        expect(data).to have_key('name')
        expect(data).to have_key('description')
        expect(data).to have_key('duration_minutes')
        expect(data).to have_key('price')
        expect(data).to have_key('status')
      end

    end

end
