# typed: true
# frozen_string_literal: true

module Api
  class MessagesPolicy < ApplicationPolicy
    def index?
      return true if user.admin? || record.users.include?(user)
      false
    end

    def create?
      # Check if the user is a participant of the chat channel
      record.users.include?(user) && user.can_send_messages?
    end
  end
end
