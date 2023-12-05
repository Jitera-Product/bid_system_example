# PATH: /app/controllers/api/chat_messages_controller.rb
class Api::ChatMessagesController < ApplicationController
  include AuthenticationConcern

  before_action :authenticate_user!
  before_action :set_chat_channel, only: [:create]
  before_action :validate_message_limit, only: [:create]

  def create
    content = params[:content]

    if content.blank?
      render json: { error: 'Content cannot be blank.' }, status: :unprocessable_entity
      return
    elsif content.length > 256
      render json: { error: 'Message exceeds 256 characters limit.' }, status: :unprocessable_entity
      return
    end

    chat_message = ChatMessage.new(content: content, chat_channel_id: @chat_channel.id, user_id: current_user.id)

    if chat_message.save
      ChatMessageBroadcastJob.perform_later(chat_message.id)
      render json: { status: 201, chat_message: ChatMessageSerializer.new(chat_message).serializable_hash[:data][:attributes] }, status: :created
    else
      render json: { errors: chat_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
    unless @chat_channel
      render json: { error: 'Chat channel not found.' }, status: :bad_request
      return
    end
  end

  def validate_message_limit
    if @chat_channel.chat_messages.count >= 500
      render json: { error: 'Maximum messages per channel is 500.' }, status: :unprocessable_entity
      return
    end
  end

  # Existing private methods remain unchanged
  ...
end
