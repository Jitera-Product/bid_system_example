class Message < ApplicationRecord
  belongs_to :chat_channel
  # validations
  validates :content, presence: { message: "The content is required." }, length: { maximum: 200, message: "You cannot input more 200 characters." }
  validate :chat_channel_must_exist, :chat_channel_must_be_open
  private
  def chat_channel_must_exist
    errors.add(:chat_channel_id, "This chat channel is not found") unless ChatChannel.exists?(self.chat_channel_id)
  end
  def chat_channel_must_be_open
    errors.add(:chat_channel_id, "This chat channel is closed") if self.chat_channel&.closed?
  end
end
