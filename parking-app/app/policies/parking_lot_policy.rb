# frozen_string_literal: true

class ParkingLotPolicy < Rhino::ResourcePolicy
  self.resource_slug = 'parking_lots'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'admin') || has_role?(user, 'manager')
    return ['id', 'name', 'address', 'total_spots'] if has_role?(user, 'member')
    []
  end
def hidden_attributes_for_show(user)
  []
end
  def permitted_attributes_for_create(user)
    return ['*'] if has_role?(user, 'admin')
    []
  end
  def permitted_attributes_for_update(user)
    return ['*'] if has_role?(user, 'admin')
    return ['name', 'address', 'total_spots'] if has_role?(user, 'manager')
    []
  end
end
