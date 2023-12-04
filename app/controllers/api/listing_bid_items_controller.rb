class Api::ListingBidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show destroy]
  def index
    @listing_bid_items = ListingBidItemService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @listing_bid_items.total_pages
  end
  def show
    @listing_bid_item = ListingBidItem.find_by(id: params[:id])
    if @listing_bid_item
      render json: @listing_bid_item
    else
      render json: { error: 'Listing bid item not found' }, status: :not_found
    end
  end
  def create
    @listing_bid_item = ListingBidItem.new(create_params)
    if @listing_bid_item.save
      render json: @listing_bid_item, status: :created
    else
      @error_object = @listing_bid_item.errors.messages
      render json: { errors: @error_object }, status: :unprocessable_entity
    end
  end
  def create_params
    params.require(:listing_bid_items).permit(:listing_id, :bid_item_id)
  end
  def destroy
    @listing_bid_item = ListingBidItem.find_by('listing_bid_items.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @listing_bid_item.blank?
    if @listing_bid_item.destroy
      head :ok, message: I18n.t('common.200')
    else
      head :unprocessable_entity
    end
  end
end
