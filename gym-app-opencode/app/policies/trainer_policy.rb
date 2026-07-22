# frozen_string_literal: true

class TrainerPolicy < ApplicationPolicy
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
    owner? || admin?
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
        scope.where(id: user.trainer_ids)
      else
        scope.active
      end
    end
  end
end