# frozen_string_literal: true

class OrderItemPolicy < Rhino::ResourcePolicy
  self.resource_slug = "order_items"

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
    return ["id", "quantity", "unit_price", "order_id", "menu_item_id", "created_at"] if current_route_group == "customer"
    []
  end

  def hidden_attributes_for_show(user)
    []
  end

  def permitted_attributes_for_create(user)
    return ["quantity", "unit_price", "order_id", "menu_item_id"] if has_role?(user, "restaurant_admin")
    return ["quantity", "unit_price", "order_id", "menu_item_id"] if current_route_group == "customer"
    []
  end

  def permitted_attributes_for_update(user)
    return ["quantity", "unit_price", "order_id", "menu_item_id"] if has_role?(user, "restaurant_admin")
    return ["quantity", "unit_price"] if current_route_group == "customer"
    []
  end

  private

  def customer_authorized?
    return false unless user
    user.user_roles.joins(:role).where(roles: { slug: "customer" }).exists?
  end
end
