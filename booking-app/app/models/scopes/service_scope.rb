# frozen_string_literal: true

module Scopes
  class ServiceScope < Rhino::ResourceScope
    # Custom query scope for Service.
    # Applied automatically to all Service queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    def apply(relation)
      if defined?(RequestStore) && RequestStore.store[:rhino_route_group] == "customer"
        relation.where(status: "active")
      else
        relation
      end
    end
  end
end
