class Api::UsersPolicy < ApplicationPolicy
  def update?
    (user.is_a?(User) && record.id == user&.id)
  end

  def update_role?
    user.role == 'admin'
  end

  def show?
    (user.is_a?(User) && record.id == user&.id)
  end

  def create?
    (user.is_a?(User) && record.id == user&.id)
  end

  def contributor?
    user.role == 'contributor'
  end

  def inquirer_role?
    user.has_role?(:inquirer)
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
