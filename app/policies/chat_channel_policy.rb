# typed: true
# frozen_string_literal: true

class ChatChannelPolicy < ApplicationPolicy
  def create?
    return false unless user && record

    # Assuming 'user_id' is the attribute of BidItem that refers to the owner
    # and 'authorized_bidders' is a method that returns users who are authorized to bid
    record.user_id == user.id || record.authorized_bidders.include?(user)
  end
end


