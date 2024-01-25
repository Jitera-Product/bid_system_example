# frozen_string_literal: true

class ChatChannel < ApplicationRecord
  # Associations
  belongs_to :bid_item
  has_many :messages, dependent: :destroy

  # Validations
  validates :status, presence: true
end
