# frozen_string_literal: true

class ParkingSpotPolicy < Rhino::ResourcePolicy
  self.resource_slug = 'parking_spots'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'admin') || has_role?(user, 'manager')
    return ['id', 'number', 'spot_type', 'is_available', 'parking_lot_id'] if has_role?(user, 'member')
    []
  end
def hidden_attributes_for_show(user)
  []
end
  def permitted_attributes_for_create(user)
    return ['*'] if has_role?(user, 'admin')
    return ['number', 'spot_type', 'is_available', 'parking_lot_id'] if has_role?(user, 'manager')
    []
  end
  def permitted_attributes_for_update(user)
    return ['*'] if has_role?(user, 'admin')
    return ['number', 'spot_type', 'is_available', 'parking_lot_id'] if has_role?(user, 'manager')
    []
  end
end
