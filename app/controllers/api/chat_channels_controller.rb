# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  before_action :authenticate_user!, only: [:request_chat_with_owner]
  before_action :set_bid_item, only: [:request_chat_with_owner]
  before_action :authorize_request_chat, only: [:request_chat_with_owner]
  # ... other actions ...
  def request_chat_with_owner
    if @bid_item.is_paid
      render json: { error: 'Chat request is not allowed for paid items.' }, status: :forbidden
    else
      chat_channel = ChatChannel.create!(
        user_id: current_user.id,
        bid_item_id: @bid_item.id,
        owner_id: @bid_item.user_id,
        is_active: true
      )
      render json: ChatChannelSerializer.new(chat_channel).serializable_hash, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
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
    authorize @bid_item, :request_chat_with_owner?
  end
end
