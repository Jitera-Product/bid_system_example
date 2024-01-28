class ChatSession < ApplicationRecord
  belongs_to :bid_item
  has_many :chat_messages

  validates :is_active, inclusion: { in: [true, false] }
  validates :bid_item_id, presence: true

  validate :bid_item_not_done
  validate :bid_item_must_be_active
  validate :active_for_closing

  # Scope to retrieve active chat sessions for a specific bid item
  scope :active_for_bid_item, ->(bid_item_id) {
    where(is_active: true, bid_item_id: bid_item_id)
  }

  # Returns the count of associated chat messages
  def message_count
    chat_messages.count
  end

  private

  def bid_item_not_done
    errors.add(:bid_item, "Chat cannot be initiated for completed bid items.") if bid_item.done?
  end

  def bid_item_must_be_active
    errors.add(:bid_item_id, I18n.t('validation.bid_item.inactive')) unless bid_item.active?
  end

  def active_for_closing
    unless is_active
      errors.add(:is_active, "Chat session cannot be closed because it is already inactive.")
    end
  end
end
