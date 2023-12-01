class Api::MessagePolicy < ApplicationPolicy
  def create?
    # Check if the current user is a member of the chat channel
    record.chat_channel.users.include?(user)
  end
end
