# frozen_string_literal: true

class TimeSlotPolicy < ApplicationPolicy
  def index?
    user.admin? || user.manager? || user.staff?
  end

  def show?
    user.admin? || user.manager? || user.staff?
  end

  def create?
    user.admin? || user.manager?
  end

  def update?
    user.admin? || user.manager? || user.staff?
  end

  def destroy?
    user.admin? || user.manager?
  end

  class Scope < Scope
    def resolve
      scope.where(organization_id: user.organization_id)
    end
  end
end