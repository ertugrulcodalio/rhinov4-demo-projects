# frozen_string_literal: true

module Scopes
  class ParkingLotScope < Rhino::ResourceScope
    def apply(relation)
      relation
    end
  end
end
