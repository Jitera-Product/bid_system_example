# frozen_string_literal: true

class ChatSessionPolicy
  attr_reader :user, :chat_session

  def initialize(user, chat_session)
    @user = user
    @chat_session = chat_session
  end

  def retrieve_chat_history?
    chat_session.participants.include?(user) || user.admin?
  end
end

