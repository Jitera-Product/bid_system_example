# FILE PATH: /app/services/deposit_listing_service.rb
# rubocop:disable Style/ClassAndModuleChildren
class DepositListingService
  attr_accessor :params, :records, :pagination_details

  def initialize(params)
    @params = params
    @records = Deposit.all
  end

  def call
    apply_filters

    order_records

    paginate_records

    {
      records: records,
      pagination: pagination_details
    }
  end

  private

  def apply_filters
    filter_by_value
    filter_by_user_id
    filter_by_wallet_id
    filter_by_status
    filter_by_payment_method_id
  end

  def filter_by_value
    return unless params[:value].present?

    @records = records.where(value: params[:value])
  end

  def filter_by_user_id
    return unless params[:user_id].present?

    @records = records.where(user_id: params[:user_id])
  end

  def filter_by_wallet_id
    return unless params[:wallet_id].present?

    @records = records.where(wallet_id: params[:wallet_id])
  end

  def filter_by_status
    return unless params[:status].present?

    @records = records.where(status: params[:status])
  end

  def filter_by_payment_method_id
    return unless params[:payment_method_id].present?

    @records = records.where(payment_method_id: params[:payment_method_id])
  end

  def order_records
    @records = records.order(created_at: :desc)
  end

  def paginate_records
    page = params[:page] || 1
    per_page = params[:per_page] || 20
    @records = records.page(page).per(per_page)
    @pagination_details = {
      current_page: records.current_page,
      total_pages: records.total_pages,
      total_count: records.total_count
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
