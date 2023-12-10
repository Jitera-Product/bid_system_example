class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update check_chat_status status chat_status]
  before_action :set_bid_item, only: [:check_chat_status, :status, :chat_status]
  before_action :validate_bid_item_status, only: [:show] # Add other actions if needed

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

  # New action to check the chat status of a bid item
  def chat_status
    render json: { status: 200, chat_enabled: @bid_item.chat_enabled }, status: :ok
  end

  # New action to get the status of a bid item
  def status
    if @bid_item
      render json: { status: 200, bid_item: { id: @bid_item.id, status: @bid_item.status } }, status: :ok
    else
      render json: { error: 'Bid item not found.' }, status: :not_found
    end
  end

  def check_chat_status
    if @bid_item.chat_enabled
      render json: { message: 'Chat feature is available.' }, status: :ok
    else
      render json: { error: 'Chat feature is not enabled for this item.' }, status: :bad_request
    end
  end

  private

  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:bid_item_id] || params[:id])
    render json: { error: 'Bid item not found.' }, status: :not_found unless @bid_item
  end

  def validate_bid_item_status
    bid_item_id = params[:id]
    bid_item = BidItem.find_by(id: bid_item_id)
    raise ActiveRecord::RecordNotFound, 'Bid item not found' unless bid_item

    if bid_item.status == 'done' # Assuming 'done' is a valid status value
      render json: { error: 'Bid item already done' }, status: :bad_request
      false
    else
      true
    end
  end
end
