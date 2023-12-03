class Api::ChatChannelsController < Api::BaseController
  include AuthenticationConcern
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :authenticate_user!, only: [:create]
  before_action :authorize_chat_channel_creation, only: [:create]
  def create
    user_id = create_params[:user_id]
    bid_item_id = create_params[:bid_item_id]
    authenticate_user!(user_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    if bid_item.nil?
      render json: { error: 'Bid item not found' }, status: :not_found
    elsif bid_item.is_paid
      render json: { error: 'Cannot create chat channel for a paid item' }, status: :forbidden
    else
      chat_channel = ChatChannel.new(user_id: user_id, owner_id: bid_item.owner_id, bid_item_id: bid_item_id, is_active: true)
      if chat_channel.save
        render json: { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }, status: :created
      else
        render json: { errors: chat_channel.errors.full_messages }, status: :unprocessable_entity
      end
    end
  rescue Exceptions::InvalidOperation => e
    render json: { error: e.message }, status: :unprocessable_entity
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  private
  def create_params
    params.require(:chat_channel).permit(:user_id, :bid_item_id)
  end
  def authenticate_user!(user_id)
    raise Exceptions::AuthenticationError.new('User must be logged in') unless current_user && current_user.id == user_id.to_i
  end
  def authorize_chat_channel_creation
    bid_item = BidItem.find_by(id: create_params[:bid_item_id])
    authorize bid_item, :create_chat_channel?
  end
end
