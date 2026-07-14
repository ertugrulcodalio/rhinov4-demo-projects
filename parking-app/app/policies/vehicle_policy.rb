# frozen_string_literal: true

class VehiclePolicy < Rhino::ResourcePolicy
  self.resource_slug = 'vehicles'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'admin') || has_role?(user, 'manager') || has_role?(user, 'member')
    []
  end
def hidden_attributes_for_show(user)
  []
end
  def permitted_attributes_for_create(user)
    return ['*'] if has_role?(user, 'admin')
    return ['license_plate', 'make', 'model', 'color', 'vehicle_type', 'user_id'] if has_role?(user, 'member')
    []
  end
  def permitted_attributes_for_update(user)
    return ['*'] if has_role?(user, 'admin')
    return ['license_plate', 'make', 'model', 'color', 'vehicle_type', 'user_id'] if has_role?(user, 'member')
    []
  end
end
