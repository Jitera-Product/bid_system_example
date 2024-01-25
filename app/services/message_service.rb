# typed: true
class MessageService < BaseService
  def send_message(chat_channel_id, user_id, content)
    MessageValidator.validate_message_content(content)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise Exceptions::InvalidParameter.new('Chat channel not found') if chat_channel.nil?
    raise Exceptions::InvalidParameter.new('Chat channel is not active') unless chat_channel.active?
    # Assuming there is a method to check message limit
    raise Exceptions::InvalidParameter.new('Message limit reached') if chat_channel.message_limit_reached?

    message = Message.new(chat_channel_id: chat_channel_id, user_id: user_id, content: content)
    message.save!
    message.id
  end
end

import '/app/models/message.rb'
import '/app/models/chat_channel.rb'
import '/app/validators/message_validator.rb'
