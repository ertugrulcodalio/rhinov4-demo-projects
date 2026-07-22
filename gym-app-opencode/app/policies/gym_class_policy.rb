# frozen_string_literal: true

class GymClassPolicy < ApplicationPolicy
  def index?
    owner? || admin? || trainer? || member?
  end

  def show?
    owner? || admin? || trainer? || member?
  end

  def create?
    owner? || admin?
  end

  def update?
    owner? || admin? || trainer?
  end

  def destroy?
    owner? || admin?
  end

  private

  def owner?
    user&.owner?
  end

  def admin?
    user&.admin?
  end

  def trainer?
    user&.trainer?
  end

  def member?
    user&.member?
  end

  class Scope < Scope
    def resolve
      if user&.owner? || user&.admin?
        scope.all
      elsif user&.trainer?
        scope.where(trainer_id: user.trainer_ids)
      else
        scope.active.upcoming
      end
    end
  end
end