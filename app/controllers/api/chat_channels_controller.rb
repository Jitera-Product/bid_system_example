# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  include Authentication
  before_action :authenticate_user!, only: [:create]
  before_action :authorize_chat_channel_creation, only: [:create]
  def create
    bid_item = BidItem.find_by(id: create_params[:bid_item_id])
    return render json: { error: 'Bid item not found' }, status: :not_found if bid_item.nil?
    return render json: { error: 'Chat channel cannot be created for a paid item' }, status: :forbidden if bid_item.is_paid
    chat_channel = ChatChannel.new(create_params)
    if chat_channel.save
      render json: { bid_item_id: chat_channel.bid_item_id, can_create_chat_channel: true }, status: :created
    else
      render json: { errors: chat_channel.errors.full_messages }, status: :unprocessable_entity
    end
  end
  private
  def create_params
    params.permit(:bid_item_id, :user_id)
  end
  def authorize_chat_channel_creation
    bid_item = BidItem.find_by(id: create_params[:bid_item_id])
    authorize bid_item, :create_chat_channel?
  end
end
