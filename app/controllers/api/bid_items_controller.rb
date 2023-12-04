class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update lock]
  before_action :set_bid_item, only: %i[show update lock]
  before_action :authorize_lock, only: :lock

  def index
    # inside service params are checked and whiteisted
    @bid_items = BidItemService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @bid_items.total_pages
  end

  def show
  end

  def create
    @bid_item = BidItem.new(create_params)

    return if @bid_item.save

    @error_object = @bid_item.errors.messages

    render status: :unprocessable_entity
  end

  def update
    return if @bid_item.update(update_params)

    @error_object = @bid_item.errors.messages

    render status: :unprocessable_entity
  end

  def lock
    begin
      BidItemLockService.new(@bid_item, current_resource_owner).execute
      render json: @bid_item, status: :ok
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  private

  def set_bid_item
    @bid_item = BidItem.find_by!('bid_items.id = ?', params[:id])
  end

  def authorize_lock
    authorize @bid_item, :lock?
  end

  def create_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end

  def update_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end
end
