class Api::V1::ShopsController < ApplicationController
  include Authentication
  include Authorization

  before_action :authenticate_user!
  before_action :set_shop, only: [:update]

  def update
    authorize ShopPolicy, :update?
    shop_id = params[:id]
    name = params[:name]
    description = params[:description]

    if name.blank?
      render json: { error: 'The name is required.' }, status: :unprocessable_entity
      return
    end

    if description.blank?
      render json: { error: 'The description is required.' }, status: :unprocessable_entity
      return
    end

    if description.length > 500
      render json: { error: 'You cannot input more than 500 characters.' }, status: :unprocessable_entity
      return
    end

    begin
      updated_shop = ShopUpdatingService.new(shop_id, name, description, current_user).update_shop
      render json: { status: 200, shop: updated_shop }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Shop not found.' }, status: :not_found
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def set_shop
    @shop = Shop.find_by(id: params[:id])
    render json: { error: 'Shop not found.' }, status: :not_found unless @shop
  end

  def shop_params
    params.require(:shop).permit(:name, :address, :description) # Updated to include description
  end
end
