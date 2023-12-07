# PATH: /app/controllers/api/v1/chat_channels_controller.rb
class Api::V1::ChatChannelsController < Api::BaseController
  before_action :authenticate_user!

  def create
    # Ensure that the user_id corresponds to a logged-in user
    unless current_resource_owner && params[:user_id].to_i == current_resource_owner.id
      render json: { error: 'User must be logged in to create a chat channel' }, status: :unauthorized and return
    end

    bid_item = BidItem.find_by(id: params[:bid_item_id])

    unless bid_item
      render json: { error: 'Bid item not found' }, status: :not_found and return
    end

    unless bid_item.chat_enabled
      render json: { error: 'Cannot create a channel for this item' }, status: :bad_request and return
    end

    if bid_item.status == 'done' # Assuming 'done' is a status indicating the bid item is already finished
      render json: { error: 'Bid item already done' }, status: :bad_request and return
    end

    chat_channel = ChatChannel.create!(bid_item_id: bid_item.id, created_at: Time.current, updated_at: Time.current)

    render json: { chat_channel_id: chat_channel.id }, status: :created
  end

  private

  def authenticate_user!
    doorkeeper_authorize! # Assuming doorkeeper_authorize! sets current_resource_owner
    super if defined?(super)
  end
end
