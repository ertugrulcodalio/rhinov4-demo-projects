# frozen_string_literal: true

module Scopes
  # Auto-applied globally to Menu via HasAutoScope.
  # In the :tenant group, organization is set by middleware — pass through;
  # BelongsToOrganization's WHERE already restricts to the current org.
  # In the :customer group, organization is nil — derive the customer's
  # restaurant from their first UserRole and filter to that org.
  class MenuScope < Rhino::ResourceScope
    def apply(relation)
      return relation if organization

      customer_org = user&.user_roles&.first&.organization
      return relation.none unless customer_org

      relation.where(organization_id: customer_org.id)
    end
  end
end
