# typed: true
# frozen_string_literal: true

module Api
  class ChatChannelsPolicy < ApplicationPolicy
    def disable?
      # Define the authorization logic for disabling a chat channel
      # Example condition: user must be an admin or the owner of the chat channel
      user.admin? || record.user_id == user.id
    end
  end
end
