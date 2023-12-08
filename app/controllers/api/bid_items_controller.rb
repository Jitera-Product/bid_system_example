class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update create_chat_channel]
  before_action :set_bid_item, only: [:create_chat_channel]

  def index
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

  def create_chat_channel
    if @bid_item.chat_enabled && @bid_item.status != 'done'
      chat_channel = ChatChannel.new(bid_item_id: @bid_item.id)
      if chat_channel.save
        render json: { status: 201, chat_channel: chat_channel.as_json }, status: :created
      else
        render json: { errors: chat_channel.errors.full_messages }, status: :unprocessable_entity
      end
    elsif !@bid_item.chat_enabled
      render json: { error: 'Can not create a channel for this item.' }, status: :bad_request
    elsif @bid_item.status == 'done'
      render json: { error: 'Bid item already done.' }, status: :bad_request
    end
  end

  private

  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:bid_item_id])
    render json: { error: 'Bid item not found' }, status: :not_found unless @bid_item
  end
end
