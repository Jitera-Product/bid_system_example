class Api::ShippingsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index show update]

  def index
    # inside service params are checked and whiteisted
    @shippings = ShippingService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @shippings.total_pages
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

  def update_params
    params.require(:shippings).permit(:shiping_address, :post_code, :phone_number, :bid_id, :status, :full_name,
                                      :email)
  end
end
