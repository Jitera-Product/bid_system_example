class ChatChannel < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :messages, dependent: :destroy

  # Validations
  validates :is_active, inclusion: { in: [true, false], message: I18n.t('activerecord.errors.messages.inclusion') }
  validates :bid_item_id, presence: true
  validate :bid_item_must_exist, :bid_item_must_be_active, :chat_channel_must_be_unique_for_bid_item

  private

  def bid_item_must_exist
    errors.add(:bid_item_id, I18n.t('activerecord.errors.messages.invalid')) unless BidItem.exists?(id: bid_item_id)
  end

  def bid_item_must_be_active
    bid_item = BidItem.find_by(id: bid_item_id)
    errors.add(:bid_item_id, I18n.t('activerecord.errors.messages.inactive')) if bid_item&.status == 'done'
  end

  def chat_channel_must_be_unique_for_bid_item
    errors.add(:bid_item_id, I18n.t('activerecord.errors.messages.taken')) if ChatChannel.exists?(bid_item_id: bid_item_id)
  end

  # Callbacks

  # Scopes

  # Methods

end
