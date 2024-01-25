class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    bid_item_id = params[:bid_item_id]
    begin
      chat_channel_id = ChatChannelService.new.create_chat_channel(bid_item_id: bid_item_id)
      render json: { chat_channel_id: chat_channel_id }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue Exceptions::AuthenticationError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
