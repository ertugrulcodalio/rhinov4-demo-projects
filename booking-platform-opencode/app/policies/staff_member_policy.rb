# frozen_string_literal: true

class StaffMemberPolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager? || user.staff?
  end

  def show?
    user.admin? || user.manager? || record == user
  end

  def create?
    user.admin? || user.manager?
  end

  def update?
    user.admin? || user.manager? || record == user
  end

  def destroy?
    user.admin?
  end

  class Scope < Scope
    def resolve
      scope.where(organization_id: user.organization_id)
    end
  end
end