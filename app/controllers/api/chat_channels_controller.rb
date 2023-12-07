class Api::ChatChannelsController < ApplicationController
  before_action :authenticate_user
  before_action :set_bid_item, only: [:create]

  # POST /api/chat_channels
  def create
    authorize ChatChannel

    if @bid_item.chat_enabled
      if @bid_item.status == 'done'
        render json: { error: 'Bid item already done.' }, status: :bad_request
      else
        chat_channel = ChatChannel.create!(user_id: current_user.id, bid_item_id: @bid_item.id)
        render json: { chat_channel_id: chat_channel.id }, status: :created
      end
    else
      render json: { error: 'Can not create a channel for this item.' }, status: :bad_request
    end
  rescue Pundit::NotAuthorizedError
    render json: { error: 'You are not authorized to perform this action.' }, status: :forbidden
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def authenticate_user
    # Assuming there's a method to authenticate the user
    # This should be implemented as per the application's authentication logic
    render json: { error: 'Not Authenticated' }, status: :unauthorized unless current_user
  end

  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:bid_item_id])
    render json: { error: 'Bid item not found' }, status: :not_found unless @bid_item
  end
end
