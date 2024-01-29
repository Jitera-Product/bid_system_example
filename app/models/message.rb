# frozen_string_literal: true

class Message < ApplicationRecord
  # Associations
  belongs_to :chat_channel

  # Validations
  validates :content, presence: true
end

