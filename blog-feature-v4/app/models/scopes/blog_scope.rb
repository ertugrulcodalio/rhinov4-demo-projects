# frozen_string_literal: true

module Scopes
  class BlogScope < Rhino::ResourceScope
    # Custom query scope for Blog.
    # Applied automatically to all Blog queries via HasAutoScope.
    #
    # Available methods: user, organization, role
    #
    def apply(relation)
      relation
    end
  end
end
