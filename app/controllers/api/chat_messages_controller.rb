# PATH: /app/controllers/api/chat_messages_controller.rb
class Api::ChatMessagesController < ApplicationController
  include AuthenticationConcern

  def create
    authenticate_user!
    chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])

    # Check if the chat_channel exists and the user is associated with it
    unless chat_channel && chat_channel.users.exists?(current_user.id)
      render json: { error: 'User is not authorized to send messages in this channel or channel does not exist.' }, status: :forbidden
      return
    end

    content = params[:content]
    if content.blank? || content.length > 256
      render json: { error: 'Message content is invalid.' }, status: :unprocessable_entity
      return
    end

    if ChatMessage.where(chat_channel_id: chat_channel.id).count >= 500
      render json: { error: 'Message limit reached for this channel.' }, status: :unprocessable_entity
      return
    end

    chat_message = ChatMessage.create!(
      content: content,
      chat_channel_id: chat_channel.id,
      user_id: current_user.id,
      created_at: Time.current,
      updated_at: Time.current
    )

    ChatMessageBroadcastJob.perform_later(chat_message.id)
    render json: { id: chat_message.id }, status: :created
  end
end
