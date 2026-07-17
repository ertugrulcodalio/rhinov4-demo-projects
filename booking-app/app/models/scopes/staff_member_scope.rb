# frozen_string_literal: true

module Scopes
  class StaffMemberScope < Rhino::ResourceScope
    # Custom query scope for StaffMember.
    # Applied automatically to all StaffMember queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    # def apply(relation)
    #   relation.where(active: true)
    # end
  end
end
