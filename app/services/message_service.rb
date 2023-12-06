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

  # Existing methods in the service (if any) should be below
end
