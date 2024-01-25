# frozen_string_literal: true

class Message < ApplicationRecord
  belongs_to :chat_channel
  belongs_to :user

  validates :content, presence: true
  validates_length_of :content, maximum: 512, too_long: 'You cannot input more than 512 characters.'
  validates :chat_channel_id, presence: true
  validates :user_id, presence: true

  # Returns the count of messages associated with the chat channel
  def message_count
    chat_channel.messages.count
  end
end
