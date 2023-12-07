class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update enable_chat]

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

  def enable_chat
    begin
      bid_item = BidItem.find_by(id: params[:bid_item_id])
      raise ActiveRecord::RecordNotFound unless bid_item

      if bid_item.user_id == current_resource_owner.id
        bid_item.update!(chat_enabled: true, updated_at: Time.current)
        render json: { message: 'Chat feature enabled successfully.' }, status: :ok
      else
        render json: { error: 'You are not authorized to enable chat for this bid item.' }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Bid item not found.' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
