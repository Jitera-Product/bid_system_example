class Api::ChatChannelsController < Api::BaseController
  before_action :authenticate_user!, only: [:create]

  def create
    bid_item = BidItem.find_by(id: chat_channel_params[:bid_item_id])
    unless bid_item
      render json: { error: 'Bid item not found' }, status: :not_found
      return
    end

    unless bid_item.is_chat_enabled
      render json: { error: 'Can not create a channel for this item' }, status: :bad_request
      return
    end

    if bid_item.status == 'done'
      render json: { error: 'Bid item already done' }, status: :bad_request
      return
    end

    chat_channel = ChatChannel.new(chat_channel_params.merge(created_at: Time.current))

    if chat_channel.save
      render json: { chat_channel_id: chat_channel.id, created_at: chat_channel.created_at }, status: :created
    else
      render json: { errors: chat_channel.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def chat_channel_params
    params.require(:chat_channel).permit(:user_id, :bid_item_id)
  end
end
