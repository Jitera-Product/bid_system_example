# rubocop:disable Style/ClassAndModuleChildren
class WithdrawalService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Withdrawal.all
  end

  def execute
    status_equal
    value_equal
    approved_id_equal
    payment_method_id_equal
    order
    paginate
    {
      records: @records,
      pagination: pagination_details
    }
  end

  private

  def status_equal
    return unless params.dig(:withdrawals, :status).present?

    @records = @records.where('status = ?', params.dig(:withdrawals, :status))
  end

  def value_equal
    return unless params.dig(:withdrawals, :value).present?

    @records = @records.where('value = ?', params.dig(:withdrawals, :value))
  end

  def approved_id_equal
    return unless params.dig(:withdrawals, :approved_id).present?

    @records = @records.where('approved_id = ?', params.dig(:withdrawals, :approved_id))
  end

  def payment_method_id_equal
    return unless params.dig(:withdrawals, :payment_method_id).present?

    @records = @records.where('payment_method_id = ?', params.dig(:withdrawals, :payment_method_id))
  end

  def order
    @records = @records.order('created_at DESC')
  end

  def paginate
    page_number = params.dig(:pagination, :page) || 1
    per_page = params.dig(:pagination, :per) || 20
    @records = @records.page(page_number).per(per_page)
  end

  def pagination_details
    {
      current_page: @records.current_page,
      total_pages: @records.total_pages,
      total_count: @records.total_count
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
