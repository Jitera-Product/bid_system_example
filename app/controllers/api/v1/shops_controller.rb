class Api::V1::ShopsController < ApplicationController
  include Authentication
  include Authorization

  before_action :authenticate_user!
  before_action :set_shop, only: [:update_shop]

  def update
    authorize ShopPolicy
    shop_id = params[:id]
    name = params[:name]
    description = params[:description] # Updated to include description

    # Validate input
    if name.blank?
      render json: { error: 'The name is required.' }, status: :unprocessable_entity
      return
    end

    if description.blank?
      render json: { error: 'The description is required.' }, status: :unprocessable_entity
      return
    end

    begin
      # Check if the shop exists
      shop = Shop.find(shop_id)

      # Update the shop's information
      updated_shop = ShopUpdatingService.new.update_shop(shop_id, name, description, current_user) # Updated to pass description

      # Log the update action
      UserActivity.create(user_id: current_user.id, activity_type: 'shop_update', description: "Updated shop information for shop_id: #{shop_id}")

      render json: updated_shop, status: :ok
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: 'Shop not found.' }, status: :not_found # Updated error message
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  # New action to handle the update of shop information
  def update_shop
    authorize ShopPolicy
    # Validate that the name and address parameters are present and not empty
    if shop_params[:name].blank? || shop_params[:address].blank?
      render json: { error: 'Name and address are required.' }, status: :bad_request
      return
    end

    # If the shop is found and the parameters are valid, update the shop's name and address
    if @shop.update(shop_params)
      # Upon successful update, return a confirmation message with a :ok status
      render json: { message: 'Shop information updated successfully.' }, status: :ok
    else
      # If the update fails due to validation errors on the model, return the errors
      render json: { errors: @shop.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # New private method to find the shop by shop_id
  def set_shop
    @shop = Shop.find_by(id: params[:shop_id])
    render json: { error: 'Shop not found.' }, status: :not_found unless @shop
  end

  # New private method to use strong parameters
  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end
