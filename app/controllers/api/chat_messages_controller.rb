# PATH: /app/controllers/api/chat_messages_controller.rb
class Api::ChatMessagesController < ApplicationController
  include AuthenticationConcern

  before_action :authenticate_user!
  before_action :set_bid_item, only: [:create_chat_channel]
  before_action :authorize_user_for_bid_item, only: [:create_chat_channel]

  def create
    # Existing code for creating a chat message remains unchanged
    ...
  end

  def create_chat_channel
    if @bid_item.chat_enabled && @bid_item.status == 'active'
      chat_channel = ChatChannel.create!(bid_item_id: @bid_item.id)
      render json: { chat_channel: chat_channel }, status: :created
    else
      render json: { error: 'Chat is not enabled for this bid item or the bid item is not active.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:bid_item_id])
    record_not_found unless @bid_item
  end

  def authorize_user_for_bid_item
    user_not_authorized unless @bid_item.user_id == current_user.id
  end

  def record_not_found
    render json: { error: 'Bid item not found.' }, status: :not_found
  end

  def user_not_authorized
    render json: { error: 'User not authorized to perform this action.' }, status: :forbidden
  end
end
