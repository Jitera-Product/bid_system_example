class Api::UsersPolicy < ApplicationPolicy
  def update?
    if user.is_a?(User) && record.id == user&.id
      true
    else
      raise "User does not have permission to access the resource"
    end
  end
  def show?
    (user.is_a?(User) && record.id == user&.id)
  end
  def create?
    user.is_a?(User)
  end
  def swipe?
    (user.is_a?(User) && record.id == user&.id)
  end
  def create_message?
    (user.is_a?(User) && record.id == user&.id)
  end
  def send_message?
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
