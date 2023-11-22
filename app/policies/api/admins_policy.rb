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

  class Scope < Scope
    def resolve
      if user.is_a?(Admin)
        scope.all.where('admins.id = ?', user&.id)

      else
        scope.none

      end
    end
  end
end
