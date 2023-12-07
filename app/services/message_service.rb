class MessageService
  # Add the new method fetch_messages below

  def fetch_messages(chat_channel_id)
    chat_channel = ChatChannel.find_by(id: chat_channel_id)
    raise ActiveRecord::RecordNotFound, "ChatChannel with id #{chat_channel_id} not found." unless chat_channel

    messages = chat_channel.messages.includes(:user).order(created_at: :asc)

    messages.map do |message|
      {
        message_id: message.id,
        sender_id: message.user.id,
        sender_name: message.user.name,
        content: message.content,
        created_at: message.created_at
      }
    end
  end

  # Add the new method send_message below

  def send_message(chat_channel_id, sender_id, content)
    ActiveRecord::Base.transaction do
      user = User.find_by_id(sender_id)
      raise "Sender not found or not logged in." unless user.present? && user.logged_in?

      chat_channel = ChatChannel.find_by_id(chat_channel_id)
      raise ActiveRecord::RecordNotFound, "ChatChannel with id #{chat_channel_id} not found." unless chat_channel

      raise "Message limit reached for this chat channel." if chat_channel.messages.count >= 500

      raise "Content can't be blank or exceed 256 characters." if content.blank? || content.length > 256

      message = Message.create!(
        chat_channel_id: chat_channel_id,
        user_id: sender_id,
        content: content,
        sent_at: Time.current
      )

      { message_id: message.id, sent_at: message.sent_at }
    end
  rescue => e
    { error: e.message }
  end

  # Existing methods in the service (if any) should be below
end
