# typed: true
# frozen_string_literal: true

class MessagePolicy < ApplicationPolicy
  def index?
    # Assuming that the user must be a participant of the chat channel to view the chat history
    record.participants.include?(user)
  end
end

# Note: The actual participant check logic will depend on the ChatChannel model's associations and methods.
