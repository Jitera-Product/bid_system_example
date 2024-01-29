class ChatChannel < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :messages, dependent: :destroy

  # Validations
  validates :is_active, inclusion: { in: [true, false] }

  # Callbacks

  # Scopes

end
