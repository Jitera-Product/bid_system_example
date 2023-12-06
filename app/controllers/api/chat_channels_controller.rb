class Api::ChatChannelsController < ApplicationController
  before_action :authenticate_user!

  def create
    bid_item = BidItem.find(params[:bid_item_id])

    unless bid_item.is_chat_enabled
      return render json: { error: 'Can not create a channel for this item' }, status: :bad_request
    end

    if bid_item.status == 'done'
      return render json: { error: 'Bid item already done' }, status: :bad_request
    end

    chat_channel = ChatChannel.create!(bid_item_id: bid_item.id, created_at: Time.current)

    render json: { chat_channel_id: chat_channel.id }, status: :created
  end

  private

  def authenticate_user!
    # Logic to authenticate user by user_id
    raise Exceptions::AuthenticationError unless current_user && current_user.id == params[:user_id].to_i
  end
end
