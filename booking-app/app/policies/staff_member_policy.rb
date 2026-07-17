# frozen_string_literal: true

class StaffMemberPolicy < Rhino::ResourcePolicy
  self.resource_slug = 'staff_members'

  def permitted_attributes_for_show(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin') || has_role?(user, 'staff')
    []
  end
def hidden_attributes_for_show(user)
  []
end
  def permitted_attributes_for_create(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin')
    []
  end
  def permitted_attributes_for_update(user)
    return ['*'] if has_role?(user, 'owner') || has_role?(user, 'admin')
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
