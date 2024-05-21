# rubocop:disable Style/ClassAndModuleChildren
class WithdrawalService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Withdrawal
  end

  def execute
    status_equal unless params.dig(:withdrawals, :status).blank?

    value_equal unless params.dig(:withdrawals, :value).blank?

    approved_id_equal unless params.dig(:withdrawals, :approved_id).blank?

    payment_method_id_equal unless params.dig(:withdrawals, :payment_method_id).blank?

    order

    paginate
  end

  def status_equal
    # Fixed typo in method name and simplified the where clause
    @records = @records.where(status: params.dig(:withdrawals, :status))
  end

  def value_equal
    @records = if records.is_a?(Class)
                 Withdrawal.where('value = ?', params.dig(:withdrawals, :value))
               else
                 records.where('value = ?', params.dig(:withdrawals, :value))
               end
  end

  def approved_id_equal
    # Fixed typo in method name and parameter name
    @records = @records.where(approved_id: params.dig(:withdrawals, :approved_id))
  end

  def payment_method_id_equal
    # Fixed typo in method name and simplified the where clause
    @records = @records.where(payment_method_id: params.dig(:withdrawals, :payment_method_id))
  end

  def order
    return if records.blank?

    @records = @records.order(created_at: :desc)
  end

  def paginate
    @records = Withdrawal.none if records.blank? || records.is_a?(Class)

    page_number = params.dig(:pagination, :page) || 1
    per_page = params.dig(:pagination, :per) || 20
    @records = records.page(page_number).per(per_page)
  end
end
# rubocop:enable Style/ClassAndModuleChildren