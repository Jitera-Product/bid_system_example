# typed: true
# frozen_string_literal: true

class ChatChannelPolicy < ApplicationPolicy
  attr_reader :user, :chat_channel

  def initialize(user, chat_channel)
    @user = user
    @chat_channel = chat_channel
  end

  def check_availability?
    # Assuming there is a method to check if the user is a participant of the chat channel
    chat_channel.participants.include?(user)
  end
end
