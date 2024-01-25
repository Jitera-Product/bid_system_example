# typed: true
# frozen_string_literal: true

module Api
  class MessagesPolicy < ApplicationPolicy
    def index?
      return true if user.admin? || record.users.include?(user)
      false
    end

    def create?
      # Assuming there's a method in user model that checks if a user can send messages
      user.can_send_messages?
    end
  end
end
