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
  def filter_notifications?
    (user.is_a?(User) && record.id == user&.id)
  end
  def create_kyc_document?
    user.is_a?(User)
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
