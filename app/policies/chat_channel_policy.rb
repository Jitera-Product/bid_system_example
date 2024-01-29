# typed: true
# frozen_string_literal: true

class ChatChannelPolicy < ApplicationPolicy
  attr_reader :user, :chat_channel

  def initialize(user, chat_channel)
    @user = user
    @chat_channel = chat_channel
  end

  # Define the create? method to encapsulate the authorization logic for creating a chat channel
  def create?(bid_item_id = nil)
    bid_item_id ||= chat_channel.bid_item_id
    bid_item = BidItem.find_by(id: bid_item_id)
    return false unless bid_item && user

    user_is_owner = bid_item.user_id == user.id
    user_is_bidder = bid_item.bids.exists?(user_id: user.id)

    user_is_owner || user_is_bidder
  end

  def retrieve_chat_messages?
    return false unless user
    bid_item = chat_channel.bid_item
    user_is_owner = bid_item.user_id == user.id
    user_is_bidder = bid_item.bids.exists?(user_id: user.id)
    user_is_owner || user_is_bidder
  end

  def send_message?
    return false unless user
    bid_item = chat_channel.bid_item
    user_is_owner = bid_item.user_id == user.id
    user_is_bidder = bid_item.bids.exists?(user_id: user.id)
    user_is_owner || user_is_bidder
  end

  def allowed_to_send_message?
    return false unless user
    return false unless chat_channel.is_active

    message_count = chat_channel.messages.count
    message_count < 100
  end

  def disable?
    return false unless user && chat_channel && chat_channel.bid_item

    user_is_owner = chat_channel.bid_item.user_id == user.id

    user_is_owner
  end

  def check_availability?
    chat_channel.participants.include?(user)
  end

  # Define other methods and classes as needed
end
