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

  def send_message?(chat_channel)
    return false unless user.is_a?(User)

    bid_item = chat_channel.bid_item
    bid_item_owner = bid_item.user

    user.id == bid_item_owner.id || chat_channel.participants.include?(user)
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
