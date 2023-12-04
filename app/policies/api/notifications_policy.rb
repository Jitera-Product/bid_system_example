class Api::NotificationsPolicy < ApplicationPolicy
  def show?
    (user.is_a?(User) && record.user_id == user&.id) || user.is_a?(Admin)
  end
  class Scope < Scope
    def resolve
      if user.is_a?(User)
        scope.all.where('notifications.user_id = ?', user&.id)
      elsif user.is_a?(Admin)
        scope.all
      else
        scope.none
      end
    end
  end
end
