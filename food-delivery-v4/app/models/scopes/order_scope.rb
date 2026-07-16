# frozen_string_literal: true

module Scopes
  # Auto-applied globally to Order via HasAutoScope.
  # :tenant group: pass through — BelongsToOrganization's WHERE
  #   restricts to the current org; restaurant sees all its customers' orders.
  # :customer group: restrict to the requesting user's own orders.
  #   Without this, a customer in the :customer group (no org middleware)
  #   would see ALL orders from all restaurants — a cross-tenant/cross-user leak.
  class OrderScope < Rhino::ResourceScope
    def apply(relation)
      return relation if organization

      return relation.none unless user

      relation.where(user_id: user.id)
    end
  end
end
