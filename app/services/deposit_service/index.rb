# rubocop:disable Style/ClassAndModuleChildren
class DepositService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Deposit
  end

  def execute
    initialize_query

    apply_value_filter if params.dig(:deposits, :value)
    apply_user_id_filter if params.dig(:deposits, :user_id)
    apply_wallet_id_filter if params.dig(:deposits, :wallet_id)
    apply_status_filter if params.dig(:deposits, :status)
    apply_payment_method_id_filter if params.dig(:deposits, :payment_method_id)

    order_query
    paginate_query

    {
      records: @records,
      pagination: {
        current_page: @records.current_page,
        total_pages: @records.total_pages,
        total_count: @records.total_count
      }
    }
  end

  private

  def initialize_query
    @records = Deposit.all
  end

  def apply_value_filter
    @records = @records.where('value = ?', params.dig(:deposits, :value))
  end

  def apply_user_id_filter
    @records = @records.where('user_id = ?', params.dig(:deposits, :user_id))
  end

  def apply_wallet_id_filter
    @records = @records.where('wallet_id = ?', params.dig(:deposits, :wallet_id))
  end

  def apply_status_filter
    @records = @records.where('status = ?', params.dig(:deposits, :status))
  end

  def apply_payment_method_id_filter
    @records = @records.where('payment_method_id = ?', params.dig(:deposits, :payment_method_id))
  end

  def order_query
    @records = @records.order('created_at DESC')
  end

  def paginate_query
    page = params.dig(:pagination_page) || 1
    per_page = params.dig(:pagination_limit) || 20
    @records = @records.page(page).per(per_page)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
