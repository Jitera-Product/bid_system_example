# /app/controllers/api/chat_channels_controller.rb

class Api::ChatChannelsController < ApplicationController
  before_action :authenticate_user!

  # Add the new create action below
  def create
    user = current_resource_owner
    return error_response('Not authorized', :unauthorized) unless user && user.id == params[:user_id].to_i

    bid_item = BidItem.find_by(id: params[:bid_item_id])
    return error_response('Bid item not found', :not_found) unless bid_item

    unless bid_item.chat_enabled
      return error_response('Can not create a channel for this item', :bad_request)
    end

    if bid_item.status == 'done'
      return error_response('Bid item already done', :bad_request)
    end

    chat_channel = ChatChannel.create!(bid_item_id: bid_item.id, created_at: Time.current, updated_at: Time.current)

    render json: { chat_channel_id: chat_channel.id }, status: :created
  rescue ActiveRecord::RecordNotFound => e
    error_response(e.message, :not_found)
  rescue ActiveRecord::RecordInvalid => e
    error_response(e.message, :unprocessable_entity)
  end

  # Existing actions (index, show, etc.) should be below the new create action

  private

  def authenticate_user!
    error_response('Not authorized', :unauthorized) unless current_resource_owner
  end

  def error_response(message, status)
    render json: { error: message }, status: status
  end
end
