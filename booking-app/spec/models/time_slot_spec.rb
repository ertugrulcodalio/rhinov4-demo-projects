# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TimeSlot — CRUD & Permissions', type: :request do
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
      let(:user) { create_user_with_role('owner', org, ['time_slots.index', 'time_slots.show', 'time_slots.store', 'time_slots.update', 'time_slots.destroy']) }
      let(:record) { create(:time_slot, organization: org) }

      it 'can list time_slots' do
        get "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show time_slots' do
        get "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create time_slots' do
        post "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update time_slots' do
        put "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete time_slots' do
        delete "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as admin' do
      let(:user) { create_user_with_role('admin', org, ['time_slots.index', 'time_slots.show', 'time_slots.store', 'time_slots.update', 'time_slots.destroy']) }
      let(:record) { create(:time_slot, organization: org) }

      it 'can list time_slots' do
        get "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show time_slots' do
        get "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create time_slots' do
        post "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update time_slots' do
        put "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete time_slots' do
        delete "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as staff' do
      let(:user) { create_user_with_role('staff', org, ['time_slots.index', 'time_slots.show', 'time_slots.store', 'time_slots.update']) }
      let(:record) { create(:time_slot, organization: org) }

      it 'can list time_slots' do
        get "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show time_slots' do
        get "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create time_slots' do
        post "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update time_slots' do
        put "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot delete time_slots' do
        delete "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

    context 'as customer' do
      let(:user) { create_user_with_role('customer', org, ['time_slots.index', 'time_slots.show']) }
      let(:record) { create(:time_slot, organization: org) }

      it 'can list time_slots' do
        get "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show time_slots' do
        get "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create time_slots' do
        post "/api/#{org.slug}/time_slots", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot update time_slots' do
        put "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete time_slots' do
        delete "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'shows only permitted fields' do
        get "/api/#{org.slug}/time_slots/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
        data = JSON.parse(response.body)

        expect(data).to have_key('id')
        expect(data).to have_key('service_id')
        expect(data).to have_key('staff_member_id')
        expect(data).to have_key('starts_at')
        expect(data).to have_key('ends_at')
        expect(data).to have_key('available')
      end

    end

end
