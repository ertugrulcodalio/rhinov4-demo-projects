# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'StaffMember — CRUD & Permissions', type: :request do
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
      let(:user) { create_user_with_role('owner', org, ['staff_members.index', 'staff_members.show', 'staff_members.store', 'staff_members.update', 'staff_members.destroy']) }
      let(:record) { create(:staff_member, organization: org) }

      it 'can list staff_members' do
        get "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show staff_members' do
        get "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create staff_members' do
        post "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update staff_members' do
        put "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete staff_members' do
        delete "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as admin' do
      let(:user) { create_user_with_role('admin', org, ['staff_members.index', 'staff_members.show', 'staff_members.store', 'staff_members.update', 'staff_members.destroy']) }
      let(:record) { create(:staff_member, organization: org) }

      it 'can list staff_members' do
        get "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show staff_members' do
        get "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create staff_members' do
        post "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update staff_members' do
        put "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete staff_members' do
        delete "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as staff' do
      let(:user) { create_user_with_role('staff', org, ['staff_members.index', 'staff_members.show']) }
      let(:record) { create(:staff_member, organization: org) }

      it 'can list staff_members' do
        get "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show staff_members' do
        get "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create staff_members' do
        post "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot update staff_members' do
        put "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete staff_members' do
        delete "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

    context 'as customer' do
      let(:user) { create_user_with_role('customer', org, []) }
      let(:record) { create(:staff_member, organization: org) }

      it 'cannot list staff_members' do
        get "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot show staff_members' do
        get "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot create staff_members' do
        post "/api/#{org.slug}/staff_members", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot update staff_members' do
        put "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete staff_members' do
        delete "/api/#{org.slug}/staff_members/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

end
