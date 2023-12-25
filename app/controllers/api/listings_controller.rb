class Api::ListingsController < Api::BaseController
  include Pagination

  before_action :doorkeeper_authorize!, only: %i[index create show update]

  def index
    # Use ListingService::Index to retrieve listings
    service = ListingService::Index.new(params, current_resource_owner)
    
    # Filter by description if provided
    service = ListingDescriptionFilter.new(service, params[:description]) if params[:description].present?
    
    # Order listings by creation date in descending order
    service = ListingCreationDateSorter.new(service)
    
    # Handle pagination
    @listings = paginate(service.execute)
    @total_pages = @listings.total_pages
    
    render json: { data: @listings, total_pages: @total_pages }
  end

  def show
    @listing = Listing.find_by!('listings.id = ?', params[:id])
  end

  def create
    @listing = Listing.new(create_params)

    if @listing.save
      render json: @listing, status: :created
    else
      @error_object = @listing.errors.messages
      render json: @error_object, status: :unprocessable_entity
    end
  end

  def create_params
    params.require(:listings).permit(:description)
  end

  def update
    @listing = Listing.find_by('listings.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @listing.blank?

    if @listing.update(update_params)
      render json: @listing, status: :ok
    else
      @error_object = @listing.errors.messages
      render json: @error_object, status: :unprocessable_entity
    end
  end

  def update_params
    params.require(:listings).permit(:description)
  end
end
