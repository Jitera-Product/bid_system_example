class ChatChannel < ApplicationRecord
  belongs_to :bid_item, foreign_key: 'bid_item_id'
  has_many :messages, foreign_key: 'chat_channel_id', dependent: :destroy

  enum status: { active: 'active', inactive: 'inactive', disabled: 'disabled' }

  # validations
  validates :status, presence: true

  def active?
    status == 'active'
  end

  def disable_channel
    raise 'Channel is already disabled' if status == 'disabled'

    self.status = 'disabled'
    save!
  end
end
