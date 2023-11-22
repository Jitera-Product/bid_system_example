# rubocop:disable Style/ClassAndModuleChildren
class DepositService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Deposit
  end

  def execute
    value_equal

    user_id_equal

    wallet_id_equal

    status_equal

    payment_method_id_equal

    order

    paginate
  end

  def value_equal
    return if params.dig(:deposits, :value).blank?

    @records = Deposit.where('value = ?', params.dig(:deposits, :value))
  end

  def user_id_equal
    return if params.dig(:deposits, :user_id).blank?

    @records = if records.is_a?(Class)
                 Deposit.where(value.query)
               else
                 records.or(Deposit.where('user_id = ?', params.dig(:deposits, :user_id)))
               end
  end

  def wallet_id_equal
    return if params.dig(:deposits, :wallet_id).blank?

    @records = if records.is_a?(Class)
                 Deposit.where(value.query)
               else
                 records.or(Deposit.where('wallet_id = ?', params.dig(:deposits, :wallet_id)))
               end
  end

  def status_equal
    return if params.dig(:deposits, :status).blank?

    @records = if records.is_a?(Class)
                 Deposit.where(value.query)
               else
                 records.or(Deposit.where('status = ?', params.dig(:deposits, :status)))
               end
  end

  def payment_method_id_equal
    return if params.dig(:deposits, :payment_method_id).blank?

    @records = if records.is_a?(Class)
                 Deposit.where(value.query)
               else
                 records.or(Deposit.where('payment_method_id = ?', params.dig(:deposits, :payment_method_id)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('deposits.created_at desc')
  end

  def paginate
    @records = Deposit.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
