class Api::MessagesController < ApplicationController
  before_action :doorkeeper_authorize!
  before_action :set_chat_channel, only: [:create]
  before_action :validate_user_belongs_to_chat_channel, only: [:create]

  # POST /api/messages
  def create
    validate_content_length(params[:content])

    if Message.where(chat_channel_id: @chat_channel.id).count >= 500
      return render json: { error: 'Message limit reached for this chat channel' }, status: :unprocessable_entity
    end

    message = Message.new(chat_channel_id: @chat_channel.id, user_id: current_user.id, content: params[:content])

    if message.save
      render json: { success: 'Message sent successfully', message: message }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by!(id: params[:chat_channel_id])
  end

  def validate_user_belongs_to_chat_channel
    unless user_belongs_to_chat_channel?(@chat_channel, current_user)
      render json: { error: 'User does not belong to this chat channel' }, status: :forbidden
    end
  end

  def user_belongs_to_chat_channel?(chat_channel, user)
    # Assuming there is a method to check if a user belongs to a chat channel
    # This is a placeholder for the actual implementation
    chat_channel.user_id == user.id || chat_channel.initiated_by_user_id == user.id
  end

  def validate_content_length(content)
    if content.length > 256
      render json: { error: 'Message content too long' }, status: :unprocessable_entity
    end
  end
end
