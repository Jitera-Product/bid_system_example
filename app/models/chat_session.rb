class ChatSession < ApplicationRecord
  belongs_to :bid_item
  has_many :chat_messages

  validates :is_active, inclusion: { in: [true, false] }
  validates :bid_item_id, presence: true

  # Additional model methods, scopes, etc. can be added below

  validate :bid_item_not_done

  private

  def bid_item_not_done
    errors.add(:bid_item, "Chat cannot be initiated for completed bid items.") if bid_item.done?
  end
end

