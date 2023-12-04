class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  def index
    @bid_items = BidItemService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @bid_items.total_pages
  end
  def show
    @bid_item = BidItem.find_by!('bid_items.id = ?', params[:id])
  end
  def create
    validator = BidItemValidator.new(create_params)
    if validator.valid?
      @bid_item = BidItemService::CreateService.new(validator.validated_data).execute
      render 'create.json.jbuilder', status: :created
    else
      @error_object = validator.errors
      render status: :unprocessable_entity
    end
  end
  def create_params
    params.require(:bid_items).permit(:user_id, :product_id, :base_price, :status, :name, :expiration_time, :description, :start_price, :current_price)
  end
  def update
    @bid_item = BidItem.find_by('bid_items.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @bid_item.blank?
    validator = BidItemValidator.new(update_params)
    unless validator.valid?
      @error_object = validator.errors
      return render status: :unprocessable_entity
    end
    update_service = BidItemService::Update.new(@bid_item, update_params)
    unless update_service.execute
      @error_object = update_service.errors
      return render status: :unprocessable_entity
    end
    @bid_item.reload
  end
  def update_params
    params.require(:bid_items).permit(:name, :description, :start_price, :current_price, :status)
  end
end
