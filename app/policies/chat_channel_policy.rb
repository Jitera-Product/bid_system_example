# typed: true
# frozen_string_literal: true

class ChatChannelPolicy < ApplicationPolicy
  attr_reader :user, :chat_channel

  def initialize(user, chat_channel)
    @user = user
    @chat_channel = chat_channel
  end

  # New method added for disabling a chat channel
  def disable?
    chat_channel.bid_item.user_id == user.id
  end

  # Existing method to check chat channel availability
  def check_availability?
    chat_channel.participants.include?(user)
  end
end
