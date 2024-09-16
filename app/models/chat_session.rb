class ChatSession < ApplicationRecord
  belongs_to :bid_item
  has_many :chat_messages, dependent: :destroy

  enum status: { active: 0, closed: 1 }, _suffix: true

  # validations
  validates :status, presence: true
  validates :status, inclusion: { in: ChatSession.statuses.keys }

  validates :bid_item_id, presence: true

  # additional logic or custom methods can be added below
end
