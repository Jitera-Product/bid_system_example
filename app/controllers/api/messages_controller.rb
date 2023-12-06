class Api::MessagesController < ApplicationController
  # ... other actions ...

  # Add the new fetch_messages action below
  def fetch_messages
    chat_channel_id = params[:chat_channel_id]
    chat_channel = ChatChannel.find_by(id: chat_channel_id)

    if chat_channel.nil?
      render json: { error: 'Chat channel not found' }, status: :not_found
    else
      messages = chat_channel.messages.includes(:user).select(
        'messages.id as message_id',
        'users.id as sender_id',
        'users.name as sender_name',
        'messages.content',
        'messages.created_at'
      )

      serialized_messages = messages.map do |message|
        {
          message_id: message.message_id,
          sender_id: message.sender_id,
          sender_name: message.sender_name,
          content: message.content,
          created_at: message.created_at
        }
      end

      render json: serialized_messages
    end
  end

  # ... other actions ...
end
