class Api::ChatChannelsController < ApplicationController
  before_action :set_chat_channel, only: [:show, :update, :destroy, :close_by_owner]
  before_action :authorize_request, except: [:select_biditem_for_chat]
  before_action :doorkeeper_authorize!, only: [:select_biditem_for_chat]

  # Other actions...

  # POST /chat_channels/1/close_by_owner
  def close_by_owner
    authorize @chat_channel, :close_by_owner?
    if @chat_channel.is_active
      if @chat_channel.update(is_active: false)
        render json: ResponseHelper.message('Chat channel successfully closed'), status: :ok
      else
        render json: ResponseHelper.error('Unable to close chat channel'), status: :unprocessable_entity
      end
    else
      render json: ResponseHelper.error('Chat channel is not available or already closed'), status: :unprocessable_entity
    end
  rescue CustomError => e
    render json: ResponseHelper.error(e.message), status: e.status
  end

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

  # Other private methods...

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
