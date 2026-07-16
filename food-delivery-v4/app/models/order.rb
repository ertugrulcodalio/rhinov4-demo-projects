# frozen_string_literal: true

class Order < Rhino::RhinoModel
  include Rhino::BelongsToOrganization

  belongs_to :user
  has_many :order_items, dependent: :destroy

  rhino_filters :status, :user_id
  rhino_sorts :created_at, :status
  rhino_default_sort "-created_at"
  rhino_fields :id, :status, :total_price, :user_id, :created_at
  rhino_includes :order_items

  validates :status, inclusion: { in: %w[pending confirmed delivered cancelled] }, allow_nil: true
  validates :total_price, numericality: true, allow_nil: true

  before_validation :set_org_from_user_role, on: :create, if: -> { organization_id.blank? && user_id.present? }

  private

  def set_org_from_user_role
    self.organization_id = user&.user_roles&.first&.organization_id
  end
end
