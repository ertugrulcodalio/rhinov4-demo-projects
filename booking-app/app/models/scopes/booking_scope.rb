# frozen_string_literal: true

module Scopes
  class BookingScope < Rhino::ResourceScope
    # Custom query scope for Booking.
    # Applied automatically to all Booking queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    def apply(relation)
      if defined?(RequestStore) && RequestStore.store[:rhino_route_group] == "customer"
        relation.where(user_id: user&.id)
      else
        relation
      end
    end
  end
end
