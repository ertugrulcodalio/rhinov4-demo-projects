# frozen_string_literal: true

class TimeSlotPolicy < Rhino::ResourcePolicy
  self.resource_slug = 'time_slots'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin') || has_role?(user, 'staff')
    return ['id', 'service_id', 'staff_member_id', 'starts_at', 'ends_at', 'available'] if has_role?(user, 'customer')
    []
  end
def hidden_attributes_for_show(user)
  []
end
  def permitted_attributes_for_create(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin') || has_role?(user, 'staff')
    []
  end
  def permitted_attributes_for_update(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin') || has_role?(user, 'staff')
    []
  end

  def create?
    return false if has_role?(user, 'customer')
    super
  end

  def update?
    return false if has_role?(user, 'customer')
    super
  end

  def destroy?
    return false if has_role?(user, 'customer')
    super
  end
end
