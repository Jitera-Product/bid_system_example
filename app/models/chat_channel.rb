# frozen_string_literal: true

class ChatChannel < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :messages, dependent: :destroy

  # Validations
  enum status: { active: 'active', disabled: 'disabled' }

  validates :status, presence: true, inclusion: { in: statuses.keys,
                                                  message: "%{value} is not a valid status" }

  # Custom validations
  # Add any custom validations here if required
end
