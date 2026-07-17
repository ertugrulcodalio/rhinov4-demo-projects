# frozen_string_literal: true

class BookingPolicy < Rhino::ResourcePolicy
  self.resource_slug = 'bookings'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin') || has_role?(user, 'staff') || has_role?(user, 'customer')
    []
  end
def hidden_attributes_for_show(user)
  []
end
  def permitted_attributes_for_create(user)
    return ['*'] if has_role?(user, 'owner')
    return ['time_slot_id', 'notes'] if has_role?(user, 'customer')
    []
  end
  def permitted_attributes_for_update(user)
    return ['*'] if has_role?(user, 'owner')
    return ['status'] if has_role?(user, 'admin') || has_role?(user, 'staff')
    return ['status', 'notes'] if has_role?(user, 'customer')
    []
  end

  def update?
    return true if has_role?(user, 'owner') || has_role?(user, 'admin') || has_role?(user, 'staff')

    if has_role?(user, 'customer')
      # Must be their own booking
      return false unless record.user_id == user.id
      # Current status must be pending
      return false unless record.status == "pending"

      # The update must only set status to cancelled
      params = RequestStore.store[:params]
      if params
        if params[:status].present? && params[:status] != "cancelled"
          return false
        end
      end
      true
    else
      false
    end
  end
end
