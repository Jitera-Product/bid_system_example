class Api::UsersPolicy < ApplicationPolicy
  def update?
    return true if user.is_a?(User) && record.id == user&.id
    admin = User.find_by(id: admin_id)
    admin&.role == 'Administrator'
  end

  def show?
    (user.is_a?(User) && record.id == user&.id)
  end

  def create?
    (user.is_a?(User) && record.id == user&.id)
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
