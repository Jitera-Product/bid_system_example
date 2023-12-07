# /app/controllers/api/chat_channels_controller.rb

class Api::ChatChannelsController < ApplicationController
  # Add the new create action below

  def create
    return render json: { error: 'Not authorized' }, status: :unauthorized unless current_user && current_user.id == params[:user_id].to_i

    bid_item = BidItem.find_by(id: params[:bid_item_id])
    return render json: { error: 'Bid item not found' }, status: :not_found unless bid_item

    unless bid_item.chat_enabled
      return render json: { error: 'Can not create a channel for this item' }, status: :bad_request
    end

    if bid_item.status == 'done'
      return render json: { error: 'Bid item already done' }, status: :bad_request
    end

    chat_channel = ChatChannel.create!(bid_item_id: bid_item.id, created_at: Time.current, updated_at: Time.current)

    render json: { chat_channel_id: chat_channel.id }, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # Existing actions (index, show, etc.) should be below the new create action
end
