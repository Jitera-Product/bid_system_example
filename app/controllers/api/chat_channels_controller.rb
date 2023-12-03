# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:select_biditem_for_chat]

  # Add the new action below
  def select_biditem_for_chat
    bid_item = BidItem.find_by(id: params[:bid_item_id])

    if bid_item.nil?
      render json: { error: 'BidItem not found' }, status: :not_found
      return
    end

    if bid_item.is_paid
      render json: { error: 'BidItem is already paid for and cannot be used for chat' }, status: :forbidden
      return
    end

    # Updated code to check if a chat channel already exists between the user and the owner of the BidItem
    chat_channel = ChatChannel.find_or_create_by(bid_item_id: bid_item.id, user_id: current_resource_owner.id, owner_id: bid_item.user_id) do |channel|
      channel.is_active = true
    end

    render json: serialize_chat_channel(chat_channel), status: :ok
  end

  private

  def serialize_chat_channel(chat_channel)
    {
      id: chat_channel.id,
      bid_item_id: chat_channel.bid_item_id,
      user_id: chat_channel.user_id,
      owner_id: chat_channel.bid_item.user_id, # Assuming bid_item has a user_id field for the owner
      is_active: chat_channel.is_active
    }
  end
end
