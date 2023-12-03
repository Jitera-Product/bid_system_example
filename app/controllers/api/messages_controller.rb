# PATH: /app/controllers/api/messages_controller.rb
class Api::MessagesController < ApplicationController
  before_action :authenticate_user, only: [:create]
  # POST /api/messages
  def create
    chat_channel = ChatChannel.find_by(id: params[:chat_channel_id], is_active: true)
    if chat_channel.nil?
      render json: { error: 'Chat channel not found or not active' }, status: :not_found
      return
    end
    if chat_channel.messages.count >= 200
      render json: { error: 'Chat channel has reached the maximum number of messages' }, status: :unprocessable_entity
      return
    end
    if params[:content].length > 200
      render json: { error: 'Message content exceeds 200 characters' }, status: :unprocessable_entity
      return
    end
    message = chat_channel.messages.new(content: params[:content], chat_channel_id: chat_channel.id, sender_id: current_user.id)
    if message.save
      render json: { message_id: message.id, created_at: message.created_at }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def authenticate_user
    # Assuming `authenticate` is a method in authentication_concern.rb that returns the current user if authenticated
    unless authenticate
      render json: { error: 'You must be logged in to send messages' }, status: :unauthorized
    end
  end
end
