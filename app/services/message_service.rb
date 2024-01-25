# typed: true
class MessageService < BaseService
  def send_message(chat_channel_id, user_id, content)
    # Validate parameters
    raise Exceptions::InvalidParameter.new('Chat channel ID must be provided and must be an integer.') unless chat_channel_id.is_a?(Integer)
    raise Exceptions::InvalidParameter.new('User ID must be provided and must be an integer.') unless user_id.is_a?(Integer)
    raise Exceptions::InvalidParameter.new('Message content must be provided and cannot exceed 512 characters.') if content.nil? || content.length > 512

    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise Exceptions::InvalidParameter.new('Chat channel not found or is not active.') if chat_channel.nil? || !chat_channel.active?

    # Assuming there is a method to check message limit
    raise Exceptions::InvalidParameter.new('Cannot send more than 30 messages per channel.') if chat_channel.message_limit_reached?

    # Assuming there is a method to check user participation in the chat channel
    raise Exceptions::Forbidden.new('User does not have permission to access the resource.') unless chat_channel.user_participant?(user_id)

    message = Message.new(chat_channel_id: chat_channel_id, user_id: user_id, content: content)
    message.save!
    message.attributes.slice('id', 'chat_channel_id', 'user_id', 'content', 'created_at')
  end
end

import '/app/models/message.rb'
import '/app/models/chat_channel.rb'
import '/app/validators/message_validator.rb'
