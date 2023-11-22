class Api::ListingBidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show destroy]

  def index
    # inside service params are checked and whiteisted
    @listing_bid_items = ListingBidItemService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @listing_bid_items.total_pages
  end

  def show
    @listing_bid_item = ListingBidItem.find_by!('listing_bid_items.id = ?', params[:id])
  end

  def create
    @listing_bid_item = ListingBidItem.new(create_params)

    return if @listing_bid_item.save

    @error_object = @listing_bid_item.errors.messages

    render status: :unprocessable_entity
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
