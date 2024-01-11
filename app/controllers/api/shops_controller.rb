class Api::ShopsController < Api::BaseController
  before_action :authenticate_admin!, only: [:update]

  def update
    shop = Shop.find_by(id: params[:shop_id])
    if shop.nil?
      render json: { error: 'Shop not found' }, status: :not_found
      return
    end

    unless params[:name].present? && params[:address].present?
      render json: { error: 'Name and address parameters are required' }, status: :unprocessable_entity
      return
    end

    update_status = ShopUpdateService.new(
      shop: shop,
      name: params[:name],
      address: params[:address],
      admin_id: current_user.id
    ).execute

    if update_status
      ShopUpdateAuditJob.perform_later(shop.id)
      render json: { success: true }
    else
      render json: { success: false }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_admin!
    # Assuming there's a method in ApplicationController that verifies admin user
    authenticate_user!
    raise 'Not authorized' unless current_user.admin?
  end
end
