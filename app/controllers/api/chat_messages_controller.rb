class Api::ChatMessagesController < ApplicationController
  include AuthenticationConcern

  before_action :authenticate_user!
  before_action :set_chat_channel, only: [:create]
  before_action :validate_message_length, only: [:create]
  before_action :validate_message_count, only: [:create]

  def create
    chat_message = @chat_channel.chat_messages.new(chat_message_params.merge(user_id: current_user.id))

    if chat_message.save
      NotificationService.new.create_notification_for_chat_message(chat_message)
      render json: { message: 'Chat message sent successfully' }, status: :created
    else
      render json: { errors: chat_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat_channel
    @chat_channel = current_user.bid_items.find_by(id: params[:chat_channel_id]).try(:chat_channel)
    unless @chat_channel
      render json: { error: 'Chat channel not found or not associated with the current user' }, status: :not_found
    end
  end

  def validate_message_length
    if params[:content].length > 256
      render json: { error: 'Message content exceeds the allowed length' }, status: :unprocessable_entity
    end
  end

  def validate_message_count
    if @chat_channel.chat_messages.count >= 500
      render json: { error: 'Message limit reached for this chat channel' }, status: :unprocessable_entity
    end
  end

  def chat_message_params
    params.require(:chat_message).permit(:content, :chat_channel_id)
  end

  def authenticate_user!
    # Assuming `authenticate_user!` is defined in the AuthenticationConcern
    super
  end
end
