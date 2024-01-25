class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :validate_bid_item_id, only: [:create]

  def create
    bid_item_id = params[:bid_item_id]
    begin
      chat_channel = ChatChannelService.new.create_chat_channel(bid_item_id: bid_item_id)
      render json: { status: 201, chat_channel: chat_channel }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :unauthorized
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

  private

  def validate_bid_item_id
    bid_item_id = params[:bid_item_id]
    unless bid_item_id.present? && bid_item_id.to_s.match?(/\A\d+\z/)
      render json: { error: 'Bid item ID must be provided and must be an integer.' }, status: :bad_request
      return
    end

    bid_item_id = bid_item_id.to_i
    unless BidItem.exists?(bid_item_id)
      render json: { error: 'Bid item not found.' }, status: :not_found
      return
    end

    # Assuming the existence of a policy named ChatChannelsPolicy
    # and a method `authorize` which checks if the user is authorized to create a chat channel
    authorize(ChatChannelsPolicy)
  end
end
