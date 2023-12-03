# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  include AuthenticationConcern
  before_action :authenticate_user!, only: [:request_chat_with_owner, :close, :create]
  before_action :set_bid_item, only: [:request_chat_with_owner, :create]
  before_action :authorize_request_chat, only: [:request_chat_with_owner, :create]
  before_action :set_chat_channel, only: [:close]
  before_action :authorize_close_chat, only: [:close]
  # ... other actions ...
  def create
    bid_item_validator = BidItemValidator.new(@bid_item, current_user)
    if bid_item_validator.valid_for_chat_channel_creation?
      existing_channel = ChatChannel.find_by(bid_item_id: @bid_item.id, user_id: current_user.id, is_active: true)
      if existing_channel
        render json: { error: 'Chat channel already exists.' }, status: :unprocessable_entity
        return
      end
      if @bid_item.is_paid
        render json: { error: 'Cannot create chat channel for paid items.' }, status: :unprocessable_entity
        return
      end
      chat_channel_creation_service = ChatChannelCreationService.new(bid_item_id: @bid_item.id, user_id: current_user.id)
      chat_channel = chat_channel_creation_service.perform
      if chat_channel.persisted?
        render json: { status: 201, chat_channel: ChatChannelSerializer.new(chat_channel).as_json }, status: :created
      else
        render json: { error: 'Failed to create chat channel.' }, status: :unprocessable_entity
      end
    else
      render json: { error: bid_item_validator.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  rescue ChatChannelPolicy::NotAuthorizedError
    render json: { error: 'You are not authorized to create a chat channel.' }, status: :forbidden
  rescue Exceptions::AuthenticationError
    render json: { error: 'You must be authenticated to perform this action.' }, status: :unauthorized
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
  def request_chat_with_owner
    # ... existing code ...
  end
  def close
    # ... existing code ...
  end
  private
  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:bid_item_id])
    unless @bid_item
      render json: { error: 'Bid item not found.' }, status: :not_found
      return
    end
  end
  def authorize_request_chat
    # ... existing code ...
  end
  def set_chat_channel
    # ... existing code ...
  end
  def authorize_close_chat
    # ... existing code ...
  end
end
