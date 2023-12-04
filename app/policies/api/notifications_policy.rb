class Api::NotificationsPolicy < ApplicationPolicy
  def update?
    (user.is_a?(User) && record.id == user&.id)
  end
  def show?
    (user.is_a?(User) && record.id == user&.id)
  end
  def create?
    (user.is_a?(User) && record.id == user&.id)
  end
  def filter_by_category?
    user.is_a?(User)
  end
  class Scope < Scope
    def resolve
      if user.is_a?(User)
        scope.where('users.id = ?', user&.id)
      else
        scope.none
      end
    end
  end
end
