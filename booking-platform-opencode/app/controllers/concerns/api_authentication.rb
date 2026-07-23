# frozen_string_literal: true

module ApiAuthentication
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_staff!
    include Pundit::Authorization
  end

  private

  def authenticate_staff!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render_unauthorized if token.blank?

    @current_staff = StaffMember.kept.find_by(api_token: token)
    return render_unauthorized unless @current_staff&.active?
  end

  def current_staff
    @current_staff
  end

  alias_method :current_user, :current_staff

  def current_organization
    current_staff&.organization
  end

  def pundit_user
    current_staff
  end

  def render_unauthorized
    render json: { errors: ["Unauthorized"] }, status: :unauthorized
  end
end