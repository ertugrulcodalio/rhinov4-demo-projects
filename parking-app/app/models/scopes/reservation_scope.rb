# frozen_string_literal: true

module Scopes
  class ReservationScope < Rhino::ResourceScope
    def apply(relation)
      relation
    end
  end
end
