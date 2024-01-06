class Api::ShopsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:update]
  before_action :set_shop, only: [:update]

  def update
    if @shop.update(shop_params)
      render json: { id: @shop.id, message: 'Shop information updated successfully.' }, status: :ok
    else
      render json: { errors: @shop.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: { error: 'Shop not found.' }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end

  private

  def set_shop
    @shop = Shop.find(params[:id])
  end

  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end

# Note: The above code assumes that there is a Shop model with :name and :address attributes
# and that the BaseController has a doorkeeper_authorize! method for authentication.
# The error messages should be customized according to the validation.en.yml file.
