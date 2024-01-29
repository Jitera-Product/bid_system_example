# typed: true
# frozen_string_literal: true

class ChatChannelPolicy < ApplicationPolicy
  def create?
    return false unless user && record

    # Assuming 'user_id' is the attribute of BidItem that refers to the owner
    # and 'authorized_bidders' is a method that returns users who are authorized to bid
    record.user_id == user.id || record.authorized_bidders.include?(user)
  end

  def show?
    user_participant?
  end

  private

  def user_participant?
    # Assuming there is a method to check if the user is a participant of the chat channel
    # and 'bid_item' is a method that returns the associated BidItem object
    # and 'messages' is a method that returns the associated messages for the ChatChannel
    # The condition has been updated to include both the new and existing checks
    record.participants.include?(user) || record.bid_item.user_id == user.id || record.messages.any? { |message| message.user_id == user.id }
  end
end
