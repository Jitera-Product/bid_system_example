class Api::ShopsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[update]
  before_action :set_shop, only: %i[update]
  before_action :validate_shop_id, only: %i[update]

  def update
    if validate_update_params(update_params)
      begin
        @shop.update!(update_params)
        ShopUpdateAuditJob.perform_later(@shop.id)
        render json: ShopSerializer.new(@shop).serialized_json
      rescue => e
        render json: { errors: e.message }, status: :unprocessable_entity
      end
    else
      render json: { errors: 'Invalid shop data' }, status: :unprocessable_entity
    end
  end

  private

  def set_shop
    @shop = Shop.find_by(id: params[:shop_id])
    render json: { error: 'Shop not found' }, status: :not_found unless @shop
  end

  def validate_shop_id
    render json: { error: 'Shop not found' }, status: :not_found unless Shop.exists?(params[:shop_id])
  end

  def update_params
    params.require(:shop).permit(:name, :address)
  end

  def validate_update_params(params)
    params[:name].present? && params[:address].present?
  end
end
