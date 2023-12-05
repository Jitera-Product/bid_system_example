# /app/controllers/api/bid_items/chat_channels_controller.rb
class Api::BidItems::ChatChannelsController < ApplicationController
  include AuthenticationConcern
  include Pundit::Authorization

  before_action :doorkeeper_authorize!, only: [:create]

  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def create
    user_id = current_resource_owner.id
    bid_item_id = params.require(:chat_channel).permit(:bid_item_id)[:bid_item_id]

    bid_item = BidItem.find_by!(id: bid_item_id)

    unless bid_item.chat_enabled
      render json: { error: "Cannot create a channel for this item" }, status: :bad_request
      return
    end

    unless bid_item.status == 'active'
      render json: { error: "Bid item already done" }, status: :bad_request
      return
    end

    authorize bid_item, :create_chat_channel?

    chat_channel = ChatChannel.create!(user_id: user_id, bid_item_id: bid_item_id)

    render json: { chat_channel_id: chat_channel.id }, status: :created
  end

  private

  def current_resource_owner
    # Assuming there is a method to retrieve the current user based on the access token provided by doorkeeper
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def record_not_found
    render json: { error: "Record not found" }, status: :not_found
  end

  def user_not_authorized
    render json: { error: "User not authorized to perform this action" }, status: :forbidden
  end
end
