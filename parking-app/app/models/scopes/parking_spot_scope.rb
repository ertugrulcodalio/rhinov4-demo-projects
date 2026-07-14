# frozen_string_literal: true

module Scopes
  class ParkingSpotScope < Rhino::ResourceScope
    def apply(relation)
      relation
    end
  end
end
