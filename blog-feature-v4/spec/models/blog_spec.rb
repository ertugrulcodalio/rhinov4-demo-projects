# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Blog — CRUD & Permissions', type: :request do
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
      let(:user) { create_user_with_role('admin', org, ['blogs.index', 'blogs.show', 'blogs.store', 'blogs.update', 'blogs.destroy']) }
      let(:record) { create(:blog, organization: org) }

      it 'can list blogs' do
        get "/api/#{org.slug}/blogs", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show blogs' do
        get "/api/#{org.slug}/blogs/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can create blogs' do
        post "/api/#{org.slug}/blogs", headers: auth_headers(user)
        expect(response.status).not_to eq(403)
      end

      it 'can update blogs' do
        put "/api/#{org.slug}/blogs/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can delete blogs' do
        delete "/api/#{org.slug}/blogs/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:no_content)
      end

    end

    context 'as user' do
      let(:user) { create_user_with_role('user', org, ['blogs.index', 'blogs.show']) }
      let(:record) { create(:blog, organization: org) }

      it 'can list blogs' do
        get "/api/#{org.slug}/blogs", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'can show blogs' do
        get "/api/#{org.slug}/blogs/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:ok)
      end

      it 'cannot create blogs' do
        post "/api/#{org.slug}/blogs", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot update blogs' do
        put "/api/#{org.slug}/blogs/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

      it 'cannot delete blogs' do
        delete "/api/#{org.slug}/blogs/#{record.id}", headers: auth_headers(user)
        expect(response).to have_http_status(:forbidden)
      end

    end

end
