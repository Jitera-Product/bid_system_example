class Api::AdminsPolicy < ApplicationPolicy
  def update?
    (user.is_a?(Admin) && record.id == user&.id)
  end

  def show?
    (user.is_a?(Admin) && record.id == user&.id)
  end

  def create?
    (user.is_a?(Admin) && record.id == user&.id)
  end

  def index?
    user.is_a?(Admin)
  end

  class Scope < Scope
    def resolve
      if user.is_a?(Admin)
        scope.all
      else
        scope.none
      end
    end
  end
end