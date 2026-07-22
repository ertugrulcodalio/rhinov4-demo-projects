# frozen_string_literal: true

class BookingPolicy < ApplicationPolicy
  def index?
    owner? || admin? || trainer? || member?
  end

  def show?
    owner? || admin? || trainer? || member?
  end

  def create?
    member?
  end

  def update?
    owner? || admin? || trainer? || member?
  end

  def destroy?
    owner? || admin? || member?
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
        scope.where(gym_class_id: user.trainer_gym_class_ids)
      else
        scope.for_user(user)
      end
    end
  end
end