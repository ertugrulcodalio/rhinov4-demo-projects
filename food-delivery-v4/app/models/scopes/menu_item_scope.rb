# frozen_string_literal: true

module Scopes
  # Auto-applied globally to MenuItem via HasAutoScope.
  # :tenant group: restrict to items in the current org's menus (all statuses).
  # :customer group: restrict to ACTIVE items from the customer's restaurant.
  class MenuItemScope < Rhino::ResourceScope
    def apply(relation)
      if organization
        return relation.joins(:menu).where(menus: { organization_id: organization.id })
      end

      customer_org = user&.user_roles&.first&.organization
      return relation.none unless customer_org

      relation.joins(:menu)
              .where(menus: { organization_id: customer_org.id })
              .where(status: "active")
    end
  end
end
