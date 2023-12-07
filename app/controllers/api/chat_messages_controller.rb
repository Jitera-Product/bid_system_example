class Api::ChatMessagesController < ApplicationController
  include AuthenticationConcern

  before_action :authenticate_user!
  before_action :set_chat_channel, only: [:create, :index]
  before_action :validate_message_length, only: [:create]
  before_action :validate_message_count, only: [:create]

  def index
    chat_messages = @chat_channel.chat_messages.order(:created_at).select(:id, :content, :created_at, :user_id)
    render json: chat_messages, status: :ok
  end

  def create
    chat_message = @chat_channel.chat_messages.new(chat_message_params.merge(user_id: current_user.id))

    if chat_message.save
      NotificationService.new.send_notification_to_bid_item_owner(chat_message)
      render json: { message: 'Chat message sent successfully', chat_message_id: chat_message.id }, status: :created
    else
      render json: { errors: chat_message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
    if @chat_channel
      bid_item = BidItem.find_by(id: @chat_channel.bid_item_id)
      unless bid_item && bid_item.status == 'active' && bid_item.chat_enabled && bid_item.user_id == current_user.id
        render json: { error: 'Chat channel not associated with an active bid item for the current user' }, status: :forbidden
      end
    else
      render json: { error: 'Chat channel not found' }, status: :not_found
    end
  end

  def validate_message_length
    content = params[:content].to_s.strip
    if content.empty?
      render json: { error: 'Message content cannot be empty' }, status: :unprocessable_entity
    elsif content.length > 256
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
