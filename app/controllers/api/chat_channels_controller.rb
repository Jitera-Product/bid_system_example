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

  def disable
    bid_item_id = params[:bid_item_id]
    unless BidItem.exists_with_id?(bid_item_id)
      render json: { error: I18n.t('api.chat_channels.bid_item_not_found') }, status: :not_found
      return
    end

    chat_channel = ChatChannel.find_by(bid_item_id: bid_item_id)
    unless chat_channel
      render json: { error: I18n.t('api.chat_channels.chat_channel_not_found') }, status: :not_found
      return
    end

    begin
      chat_channel.disable_channel
      render json: { message: I18n.t('api.chat_channels.chat_channel_disabled') }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
