# frozen_string_literal: true

module Scopes
  # Auto-applied globally to OrderItem via HasAutoScope.
  # :tenant group: restrict to items from orders in the current org.
  # :customer group: restrict through orders to the requesting user's own items.
  class OrderItemScope < Rhino::ResourceScope
    def apply(relation)
      if organization
        return relation.joins(:order).where(orders: { organization_id: organization.id })
      end

      return relation.none unless user

      relation.joins(:order).where(orders: { user_id: user.id })
    end
  end
end
