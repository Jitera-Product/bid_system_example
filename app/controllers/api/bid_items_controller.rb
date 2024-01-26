
class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update disable_chat_session]
  before_action :set_bid_item, only: [:disable_chat_session]

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

  def disable_chat_session
    if @bid_item.status_done?
      active_chat_sessions = @bid_item.chat_sessions.where(is_active: true)
      active_chat_sessions.update_all(is_active: false)
      message = I18n.t('common.chat_sessions.disabled', count: active_chat_sessions.size)
      render json: { message: message }, status: :ok
    else
      render json: { message: "Chat session can only be disabled for completed bid items" }, status: :forbidden
    end
  rescue ActiveRecord::RecordNotFound
    base_render_record_not_found
  end

  private

  def set_bid_item
    @bid_item = BidItem.find_by!(id: params[:id])
  end
end
