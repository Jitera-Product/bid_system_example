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

  # New method added according to the guideline
  def edit_question?
    user.has_role?(:contributor) && record.user_id == user.id
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
