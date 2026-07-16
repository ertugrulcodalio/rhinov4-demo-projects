# frozen_string_literal: true

class OrderPolicy < Rhino::ResourcePolicy
  self.resource_slug = "orders"

  def index?
    return customer_authorized? if current_route_group == "customer"
    super
  end

  def show?
    return customer_authorized? if current_route_group == "customer"
    super
  end

  def create?
    return customer_authorized? if current_route_group == "customer"
    super
  end

  def update?
    return customer_authorized? if current_route_group == "customer"
    super
  end

  def destroy?
    return customer_authorized? if current_route_group == "customer"
    super
  end

  def permitted_attributes_for_show(user)
    return ["*"] if has_role?(user, "restaurant_admin")
    return ["id", "status", "total_price", "user_id", "created_at"] if current_route_group == "customer"
    []
  end

  def hidden_attributes_for_show(user)
    []
  end

  def permitted_attributes_for_create(user)
    return ["status", "total_price", "user_id"] if has_role?(user, "restaurant_admin")
    return ["status", "total_price", "user_id"] if current_route_group == "customer"
    []
  end

  def permitted_attributes_for_update(user)
    return ["status"] if has_role?(user, "restaurant_admin")
    return ["status"] if current_route_group == "customer"
    []
  end

  private

  def customer_authorized?
    return false unless user
    user.user_roles.joins(:role).where(roles: { slug: "customer" }).exists?
  end
end
