class ChatChannel < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :messages, dependent: :destroy

  # Validations
  validates :is_active, inclusion: { in: [true, false], message: I18n.t('activerecord.errors.messages.inclusion') }
  validates :bid_item_id, presence: true
  validate :bid_item_must_exist, :bid_item_must_be_active, :chat_channel_must_be_unique_for_bid_item, :validate_chat_channel_availability

  private

  def bid_item_must_exist
    errors.add(:bid_item_id, I18n.t('activerecord.errors.messages.invalid')) unless BidItem.exists?(id: bid_item_id)
  end

  def bid_item_must_be_active
    bid_item = BidItem.find_by(id: bid_item_id)
    errors.add(:bid_item_id, I18n.t('activerecord.errors.messages.inactive')) if bid_item&.status == 'done'
  end

  def chat_channel_must_be_unique_for_bid_item
    # The new code checks for an active chat channel, which is more specific and thus we keep this condition
    errors.add(:bid_item_id, I18n.t('activerecord.errors.messages.taken')) if ChatChannel.exists?(bid_item_id: bid_item_id, is_active: true)
  end

  def validate_chat_channel_availability
    bid_item = BidItem.find_by(id: bid_item_id)
    if bid_item&.status != 'active'
      errors.add(:bid_item_id, I18n.t('validation.errors.bid_item_inactive'))
    elsif ChatChannel.where(bid_item_id: bid_item_id, is_active: true).exists?
      errors.add(:bid_item_id, I18n.t('validation.errors.chat_channel_exists'))
    end
  end

  # Callbacks

  # Scopes

  # Methods

end
