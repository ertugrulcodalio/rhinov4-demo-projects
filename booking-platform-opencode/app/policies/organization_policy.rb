# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager?
  end

  def show?
    user.admin? || user.manager?
  end

  def create?
    user.admin?
  end

  def update?
    user.admin? || user.manager?
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.where(id: user.organization_id)
    end
  end
end