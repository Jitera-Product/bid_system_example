class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update create_chat_channel check_chat_status]
  before_action :find_bid_item, only: [:create_chat_channel, :check_chat_status]
  before_action :check_bid_item_status, only: [:create_chat_channel]

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
    unless @bid_item.chat_enabled
      render json: { error: 'Can not create a channel for this item.' }, status: :forbidden
      return
    end

    if @bid_item.status == 'done'
      render json: { error: 'Bid item already done' }, status: :bad_request
      return
    end

    begin
      chat_channel = MessageService.create_chat_channel(@bid_item)
      render json: { status: 201, chat_channel: chat_channel }, status: :created
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def check_chat_status
    if @bid_item.nil?
      render json: { error: 'Bid item not found' }, status: :not_found
      return
    end

    if @bid_item.chat_enabled
      render json: { message: 'Chat feature is available for this item' }, status: :ok
    else
      render json: { error: 'Chat feature is disabled for this item' }, status: :bad_request
    end
  end

  private

  def find_bid_item
    @bid_item = BidItem.find_by(id: params[:bid_item_id])
    render json: { error: 'Bid item not found' }, status: :not_found if @bid_item.nil?
  end

  def check_bid_item_status
    if @bid_item.status == 'done'
      render json: { error: 'Bid item already done' }, status: :bad_request
    end
  end
end
