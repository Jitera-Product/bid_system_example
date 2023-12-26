# rubocop:disable Style/ClassAndModuleChildren
class PaymentMethodService::Index
  attr_accessor :params, :records, :query, :current_user

  def initialize(params, current_user = nil)
    @params = params
    @current_user = current_user
    @records = PaymentMethod
  end

  def execute
    begin
      user_id_equal
      primary_equal
      method_equal
      order
      paginate
    rescue StandardError => e
      handle_error(e)
    end
  end

  private

  def user_id_equal
    return if params.dig(:wallets, :user_id).blank?

    @records = records.where(user_id: params.dig(:wallets, :user_id))
  end

  def primary_equal
    return if params.dig(:wallets, :primary).blank?

    @records = records.where(primary: params.dig(:wallets, :primary))
  end

  def method_equal
    return if params.dig(:wallets, :method).blank?

    @records = records.where(method: params.dig(:wallets, :method))
  end

  def order
    @records = records.order(created_at: :desc)
  end

  def paginate
    page_number = params.dig(:pagination, :page) || 1
    per_page = params.dig(:pagination, :limit) || 20
    @records = records.page(page_number).per(per_page) if records.respond_to?(:page)
  end

  def handle_error(error)
    # Log the error or send it to an error tracking service
    Rails.logger.error("PaymentMethodService::Index encountered an error: #{error.message}")
    # You can define how you want to handle the error, e.g., return an empty array or raise the error
    raise error
  end
end
# rubocop:enable Style/ClassAndModuleChildren
