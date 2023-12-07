class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update disable_chat enable_chat check_chat_status validate_bid_item_status chat_status]
  before_action :set_bid_item, only: %i[show update disable_chat enable_chat check_chat_status chat_status]

  def index
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

  def create_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end

  def update
    return if @bid_item.update(update_params)

    @error_object = @bid_item.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time)
  end

  def disable_chat
    if @bid_item.user_id == current_resource_owner.id
      begin
        @bid_item.update!(chat_enabled: false, updated_at: Time.current)
        render json: { message: 'Chat feature has been disabled', bid_item_id: @bid_item.id, chat_enabled: @bid_item.chat_enabled }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized to disable chat for this bid item' }, status: :unauthorized
    end
  end

  def enable_chat
    if @bid_item.user_id == current_resource_owner.id
      begin
        @bid_item.update!(chat_enabled: true, updated_at: Time.current)
        render json: { message: 'Chat feature enabled successfully.' }, status: :ok
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to enable chat for this bid item.' }, status: :forbidden
    end
  end

  def check_chat_status
    if @bid_item.chat_enabled
      render json: { message: 'Chat can be initiated.' }, status: :ok
    else
      render json: { error: 'Chat feature is not enabled for this item.' }, status: :bad_request
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Bid item not found' }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def validate_bid_item_status
    bid_item = BidItem.find_by(id: params[:bid_item_id])
    unless bid_item
      render json: { error: 'Bid item not found' }, status: :not_found
      return
    end

    status = bid_item.status
    if status == 'done'
      render json: { bid_item_status: 'done' }, status: :ok
    else
      render json: { bid_item_status: 'open' }, status: :ok
    end
  end

  def chat_status
    if @bid_item.chat_enabled
      render json: { status: 200, chat_enabled: true }, status: :ok
    else
      render json: { status: 200, chat_enabled: false }, status: :ok
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Bid item not found' }, status: :not_found
  rescue => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  private

  def set_bid_item
    @bid_item = BidItem.find_by(id: params[:id] || params[:bid_item_id])
    raise ActiveRecord::RecordNotFound unless @bid_item
  end
end
