# typed: true
# frozen_string_literal: true

module Api
  class ChatSessionPolicy < ApplicationPolicy
    def create?
      # Assuming the user is allowed to create a chat session if they are authenticated
      # and the bid item is not completed. Further checks should be implemented based
      # on business logic.
      user.present? && record.status != 'done'
    end
  end
end
