# frozen_string_literal: true

module Scopes
  class VehicleScope < Rhino::ResourceScope
    def apply(relation)
      relation
    end
  end
end
