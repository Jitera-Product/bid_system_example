# typed: true
# frozen_string_literal: true

module Api
  class MessagesPolicy < ApplicationPolicy
    def index?
      return true if user.admin? || record.users.include?(user)
      false
    end
  end
end

# Note: The record is expected to be an instance of ChatChannel
# and it is assumed that ChatChannel has a users association method.
