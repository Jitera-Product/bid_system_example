class Api::V1::ShopsController < ApplicationController
  include Authentication
  include Authorization

  before_action :authenticate_user!

  def update
    authorize ShopPolicy
    shop_id = params[:id]
    name = params[:name]
    address = params[:address]

    # Validate input
    if name.blank? || address.blank?
      render json: { error: 'Name and address cannot be blank' }, status: :unprocessable_entity
      return
    end

    begin
      # Check if the shop exists
      shop = Shop.find(shop_id)

      # Update the shop's information
      updated_shop = ShopUpdatingService.new.update_shop(shop_id, name, address, current_user)

      # Log the update action
      UserActivity.create(user_id: current_user.id, activity_type: 'shop_update', description: "Updated shop information for shop_id: #{shop_id}")

      render json: updated_shop, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
