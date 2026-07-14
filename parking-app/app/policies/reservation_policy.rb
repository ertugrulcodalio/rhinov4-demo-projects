# frozen_string_literal: true

class ReservationPolicy < Rhino::ResourcePolicy
  self.resource_slug = 'reservations'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'admin') || has_role?(user, 'manager') || has_role?(user, 'member')
    []
  end
def hidden_attributes_for_show(user)
  []
end
  def permitted_attributes_for_create(user)
    return ['*'] if has_role?(user, 'admin')
    return [
        'start_time',
        'end_time',
        'status',
        'total_cost',
        'notes',
        'vehicle_id',
        'parking_spot_id',
        'user_id',
      ] if has_role?(user, 'manager') || has_role?(user, 'member')
    []
  end
  def permitted_attributes_for_update(user)
    return ['*'] if has_role?(user, 'admin')
    return [
        'start_time',
        'end_time',
        'status',
        'total_cost',
        'notes',
        'vehicle_id',
        'parking_spot_id',
        'user_id',
      ] if has_role?(user, 'manager')
    []
  end
end
