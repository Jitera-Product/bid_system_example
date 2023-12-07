# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:create]
  before_action :set_bid_item, only: [:create]
  before_action :validate_chat_creation, only: [:create]

  def create
    chat_channel = ChatChannel.new(bid_item_id: @bid_item.id, created_at: Time.current, updated_at: Time.current)

    if chat_channel.save
      render json: { chat_channel_id: chat_channel.id, created_at: chat_channel.created_at }, status: :created
    else
      render json: { errors: chat_channel.errors.full_messages }, status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: { errors: e.message }, status: :internal_server_error
  end

  private

  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:bid_item_id])
    render json: { error: 'Bid item not found' }, status: :not_found unless @bid_item
  end

  def validate_chat_creation
    if @bid_item.chat_enabled == false
      render json: { error: 'Can not create a channel for this item.' }, status: :bad_request and return
    elsif @bid_item.status == 'done' # Assuming 'done' is a valid status
      render json: { error: 'Bid item already done.' }, status: :bad_request and return
    end
  end
end
