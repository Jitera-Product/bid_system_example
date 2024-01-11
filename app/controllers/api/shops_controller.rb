class Api::ShopsController < Api::BaseController
  before_action :authenticate_admin!, only: [:update]

  def update
    unless params[:id].to_s.match?(/\A\d+\z/)
      render json: { error: 'ID must be a number.' }, status: :bad_request
      return
    end

    shop = Shop.find_by(id: params[:id])
    if shop.nil?
      render json: { error: 'Shop not found' }, status: :not_found
      return
    end

    error_messages = []
    error_messages << 'Name is required.' unless params[:name].present?
    error_messages << 'Address is required.' unless params[:address].present?
    error_messages << 'Phone is required.' unless params[:phone].present?

    unless error_messages.empty?
      render json: { error: error_messages.join(' ') }, status: :unprocessable_entity
      return
    end

    update_status = ShopUpdateService.new(
      shop: shop,
      name: params[:name],
      address: params[:address],
      phone: params[:phone],
      admin_id: current_user.id
    ).execute

    if update_status[:success]
      ShopUpdateAuditJob.perform_later(shop.id)
      render json: { status: 200, shop: shop.as_json.merge(updated_at: Time.current) }
    else
      render json: { error: update_status[:error] }, status: update_status[:status] || :unprocessable_entity
    end
  end

  private

  def authenticate_admin!
    authenticate_user!
    raise 'Not authorized' unless current_user.admin?
  end
end
