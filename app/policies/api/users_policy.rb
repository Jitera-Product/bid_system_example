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

  class Scope < Scope
    def resolve
      if user.is_a?(User)
        scope.all.where('users.id = ?', user&.id)
      else
        scope.none
      end
    end
  end

  def check_inquirer_role(user)
    user.role == 'inquirer'
  end

  def admin?(user)
    user.role == 'admin'
  end

  # Updated method to check if the user can update roles
  def update_role?
    admin?(user)
  end
end
