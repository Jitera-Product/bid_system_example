class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!
  before_action :validate_bid_item_id, only: [:create]

  def create
    bid_item_id = params[:bid_item_id]
    begin
      chat_channel = ChatChannelService.new.create_chat_channel(bid_item_id: bid_item_id)
      render json: { chat_channel_id: chat_channel.id }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue Exceptions::AuthenticationError, Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def disable
    chat_channel_id = params[:id].to_i
    if chat_channel_id <= 0
      render json: { error: 'Chat channel ID must be provided and must be an integer.' }, status: :bad_request
      return
    end

    chat_channel = ChatChannel.find_by(id: chat_channel_id) || ChatChannel.find_by(bid_item_id: params[:bid_item_id])
    unless chat_channel
      render json: { error: 'Chat channel not found.' }, status: :not_found
      return
    end

    authorize chat_channel, :disable?

    begin
      ChatChannelService.new.disable_chat_channel(bid_item_id: chat_channel.bid_item_id)
      render json: { status: 200, chat_channel: { id: chat_channel.id, status: 'disabled', updated_at: Time.now } }, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue ChatChannelService::ChatChannelAlreadyDisabledError => e
      render json: { error: e.message }, status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError => e
      render json: { error: 'User does not have permission to access the resource.' }, status: :forbidden
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
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
