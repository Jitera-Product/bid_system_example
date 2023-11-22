class Api::ListingsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # inside service params are checked and whiteisted
    @listings = ListingService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @listings.total_pages
  end

  def show
    @listing = Listing.find_by!('listings.id = ?', params[:id])
  end

  def create
    @listing = Listing.new(create_params)

    return if @listing.save

    @error_object = @listing.errors.messages

    render status: :unprocessable_entity
  end

  def create_params
    params.require(:listings).permit(:description)
  end

  def update
    @listing = Listing.find_by('listings.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @listing.blank?

    return if @listing.update(update_params)

    @error_object = @listing.errors.messages

    render status: :unprocessable_entity
  end

  def update_params
    params.require(:listings).permit(:description)
  end
end
