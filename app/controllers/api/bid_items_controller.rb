class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update check_chat_status check_status status]

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

  def check_chat_status
    bid_item = BidItem.find_by(id: params[:bid_item_id])

    if bid_item.nil?
      render json: { chat_status: 'disabled' }, status: :not_found
    elsif bid_item.chat_enabled
      render json: { chat_status: 'enabled' }
    else
      render json: { chat_status: 'disabled' }
    end
  rescue ActionController::ParameterMissing
    render json: { error: 'Parameter bid_item_id is required' }, status: :bad_request
  end

  def check_status
    begin
      @bid_item = BidItem.find_by!(id: params[:bid_item_id])
      status = @bid_item.status == 'active' ? 'active' : 'done'
      render json: { status: status }
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Bid item not found' }, status: :not_found
    end
  end

  # New action to retrieve the status of a bid item by its ID
  def status
    bid_item = BidItem.find_by(id: params[:id])

    if bid_item.nil?
      render json: { error: 'Bid item not found' }, status: :not_found
    else
      render json: { status: 200, bid_item_status: bid_item.status }, status: :ok
    end
  rescue ActionController::ParameterMissing
    render json: { error: 'Parameter id is required' }, status: :bad_request
  end
end
