class Api::ChatChannelsPolicy < ApplicationPolicy
  # Other methods...
  def close?
    user.present? && record.bid_item.user_id == user.id
  end
  def create?
    user.present?
  end
end
