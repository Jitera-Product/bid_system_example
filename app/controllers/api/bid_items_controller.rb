class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update check_chat_availability]
  before_action :set_chat_channel, only: [:check_chat_availability]

  def index
    # inside service params are checked and whiteisted
    @bid_items = BidItemService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @bid_items.total_pages
  end

  def show
    @bid_item = BidItem.find_by!('bid_items.id = ?', params[:id])
  end

  def create
    @bid_item = BidItem.new(create_params)

    return if @bid_item.save

    @error_object = @bid_item.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end

  def update
    @bid_item = BidItem.find_by('bid_items.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @bid_item.blank?

    return if @bid_item.update(update_params)

    @error_object = @bid_item.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end

  def check_chat_availability
    if @chat_channel.bid_item.status == 'done'
      render json: { availability: { chat_channel_id: @chat_channel.id, is_available: false } }, status: :ok
    elsif @chat_channel.messages.count < 30
      render json: { availability: { chat_channel_id: @chat_channel.id, is_available: true } }, status: :ok
    else
      render json: { availability: { chat_channel_id: @chat_channel.id, is_available: false } }, status: :ok
    end
  end

  private

  def set_chat_channel
    @chat_channel = ChatChannel.active.find_by!(bid_item_id: params[:chat_channel_id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: "Chat channel not found." }, status: :not_found
  end

  # Existing method from the old code, retained for compatibility
  def count_messages(chat_channel_id)
    ChatChannel.find(chat_channel_id).messages.count
  end
end
