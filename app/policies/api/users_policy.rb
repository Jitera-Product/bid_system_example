class Api::UsersPolicy < ApplicationPolicy
  def update?
    (user.is_a?(User) && record.id == user&.id)
  end

  def show?
    (user.is_a?(User) && record.id == user&.id)
  end

  def create?
    (user.is_a?(User) && record.id == user&.id)
  end

  def update_role?
    user.is_a?(User) && user.role == 'Administrator'
  end


  class Scope < Scope
    def resolve
      if user.is_a?(User)
        scope.all.where('users.id = ?', user&.id)

      else
        scope.none

      end
    end
  end
end
