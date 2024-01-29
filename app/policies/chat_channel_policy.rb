# typed: true
# frozen_string_literal: true

class ChatChannelPolicy < ApplicationPolicy
  def create?
    return false unless user && record

    record.user_id == user.id || record.authorized_bidders.include?(user)
  end

  def show?
    user_participant?
  end

  def disable?
    user.id == record.bid_item.user_id
  end

  class Scope < Scope
    def resolve
      scope.where(bid_item: { user_id: user.id })
    end
  end

  private

  def user_participant?
    record.participants.include?(user) || record.bid_item.user_id == user.id || record.messages.any? { |message| message.user_id == user.id }
  end
end
