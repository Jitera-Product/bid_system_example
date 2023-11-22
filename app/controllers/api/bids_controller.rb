class Api::BidsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # inside service params are checked and whiteisted
    @bids = BidService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @bids.total_pages
  end

  def show
    @bid = Bid.find_by!('bids.id = ?', params[:id])
  end

  def create
    @bid = Bid.new(create_params)

    return if @bid.save

    @error_object = @bid.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:bids).permit(:price, :item_id, :user_id, :status)
  end

  def update
    @bid = Bid.find_by('bids.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @bid.blank?

    return if @bid.update(update_params)

    @error_object = @bid.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:bids).permit(:price, :item_id, :user_id, :status)
  end
end
