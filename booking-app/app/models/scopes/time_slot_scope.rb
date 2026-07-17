# frozen_string_literal: true

module Scopes
  class TimeSlotScope < Rhino::ResourceScope
    # Custom query scope for TimeSlot.
    # Applied automatically to all TimeSlot queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    def apply(relation)
      if defined?(RequestStore) && RequestStore.store[:rhino_route_group] == "customer"
        relation.where(available: true)
      else
        relation
      end
    end
  end
end
