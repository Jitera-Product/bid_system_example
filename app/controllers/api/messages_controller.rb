# PATH: /app/controllers/api/messages_controller.rb
class Api::MessagesController < ApplicationController
  include AuthenticationConcern
  include ChatChannelConcern
  def create
    authenticate_user!
    chat_channel = find_chat_channel(params[:chat_channel_id])
    if chat_channel.nil? || !chat_channel.is_active
      render json: { error: 'Chat channel not found or inactive' }, status: :not_found
      return
    end
    unless [chat_channel.user_id, chat_channel.owner_id].include?(current_user.id)
      render json: { error: 'User not authorized to send message in this channel' }, status: :forbidden
      return
    end
    if params[:content].length > 200
      render json: { error: 'You cannot input more than 200 characters.' }, status: :unprocessable_entity
      return
    end
    message = Message.new(chat_channel_id: chat_channel.id, sender_id: current_user.id, content: params[:content], created_at: Time.current)
    if message.save
      # Enqueue the MessageBroadcastJob after the message is saved
      MessageBroadcastJob.perform_later(message)
      render json: {
        status: 201,
        message: {
          id: message.id,
          chat_channel_id: message.chat_channel_id,
          sender_id: message.sender_id,
          content: message.content,
          created_at: message.created_at.iso8601
        }
      }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def find_chat_channel(chat_channel_id)
    ChatChannel.find_by(id: chat_channel_id)
  end
end
