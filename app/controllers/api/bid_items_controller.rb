class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update check_chat_status]

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

  # New method to check the chat status of a bid item
  def check_chat_status
    bid_item = BidItem.find_by(id: params[:bid_item_id])
    if bid_item
      render json: { chat_enabled: bid_item.chat_enabled }
    else
      render json: { error: I18n.t('common.404') }, status: :not_found
    end
  end
end
