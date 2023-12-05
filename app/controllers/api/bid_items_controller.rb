class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update create_chat_channel]

  # ... other actions ...

  def create_chat_channel
    bid_item = BidItem.find_by(id: params[:bid_item_id])

    unless bid_item
      render json: { error: 'Bid item not found' }, status: :not_found
      return
    end

    unless bid_item.chat_enabled
      render json: { error: 'Can not create a channel for this item.' }, status: :forbidden
      return
    end

    if bid_item.status == 'done'
      render json: { error: 'Bid item already done.' }, status: :forbidden
      return
    end

    chat_channel = ChatChannel.new(bid_item: bid_item, user: current_resource_owner)

    if chat_channel.save
      render json: { status: 201, chat_channel: chat_channel.as_json(only: [:id, :created_at, :bid_item_id, :user_id]) }, status: :created
    else
      render json: { errors: chat_channel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # ... other private methods ...
end
