class Api::ShippingsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update]

  def index
    begin
      # Initialize the ShippingService with the given parameters.
      service_response = ShippingService::Index.new(shipping_params, current_resource_owner).execute
      render json: {
        records: service_response[:records],
        pagination: service_response[:pagination]
      }, status: :ok
    rescue AuthenticationError => e
      render json: { error: e.message }, status: :unauthorized
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  def show
    @shipping = Shipping.find_by!('shippings.id = ?', params[:id])
  end

  def update
    @shipping = Shipping.find_by('shippings.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @shipping.blank?

    return if @shipping.update(update_params)

    @error_object = @shipping.errors.messages

    render status: :unprocessable_entity
  end

  private

  # Strong parameters for shipping index action
  def shipping_params
    params.permit(:page, :per_page, :sort_by, :sort_order, :filter, :shipping_address, :post_code, :phone_number, :bid_id, :status, :full_name, :email)
  end

  def update_params
    params.require(:shippings).permit(:shipping_address, :post_code, :phone_number, :bid_id, :status, :full_name,
                                      :email)
  end
end
