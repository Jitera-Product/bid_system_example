class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  def index
    @bid_items = BidItemService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @bid_items.total_pages
  end
  def show
    begin
      @bid_item = BidItem.select(:id, :owner_id, :title, :description, :is_paid).find_by(id: params[:id])
      raise CustomException::NotFound.new('BidItem not found') unless @bid_item
      render json: @bid_item, status: :ok
    rescue CustomException::NotFound => e
      render json: { error: e.message }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
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
end
