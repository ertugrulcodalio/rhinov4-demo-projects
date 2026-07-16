# frozen_string_literal: true

class MenuItemPolicy < Rhino::ResourcePolicy
  self.resource_slug = "menu_items"

  def index?
    return customer_authorized? if current_route_group == "customer"
    super
  end

  def show?
    return customer_authorized? if current_route_group == "customer"
    super
  end

  def create?
    return false if current_route_group == "customer"
    super
  end

  def update?
    return false if current_route_group == "customer"
    super
  end

  def destroy?
    return false if current_route_group == "customer"
    super
  end

  def permitted_attributes_for_show(user)
    return ["*"] if has_role?(user, "restaurant_admin")
    return ["id", "name", "description", "price", "status", "menu_id", "created_at"] if current_route_group == "customer"
    []
  end

  def hidden_attributes_for_show(user)
    []
  end

  def permitted_attributes_for_create(user)
    return ["name", "description", "price", "status", "menu_id"] if has_role?(user, "restaurant_admin")
    []
  end

  def permitted_attributes_for_update(user)
    return ["name", "description", "price", "status", "menu_id"] if has_role?(user, "restaurant_admin")
    []
  end

  private

  def customer_authorized?
    return false unless user
    user.user_roles.joins(:role).where(roles: { slug: "customer" }).exists?
  end
end
