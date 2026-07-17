# frozen_string_literal: true

class ServicePolicy < Rhino::ResourcePolicy
  self.resource_slug = 'services'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin') || has_role?(user, 'staff')
    return ['id', 'name', 'description', 'duration_minutes', 'price', 'status'] if has_role?(user, 'customer')
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
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin')
    return ['name', 'description', 'duration_minutes', 'price'] if has_role?(user, 'staff')
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
