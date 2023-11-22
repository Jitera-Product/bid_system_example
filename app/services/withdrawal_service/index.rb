# rubocop:disable Style/ClassAndModuleChildren
class WithdrawalService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Withdrawal
  end

  def execute
    status_equal

    value_equal

    aprroved_id_equal

    payment_method_id_equal

    order

    paginate
  end

  def status_equal
    return if params.dig(:withdrawals, :status).blank?

    @records = Withdrawal.where('status = ?', params.dig(:withdrawals, :status))
  end

  def value_equal
    return if params.dig(:withdrawals, :value).blank?

    @records = if records.is_a?(Class)
                 Withdrawal.where(value.query)
               else
                 records.or(Withdrawal.where('value = ?', params.dig(:withdrawals, :value)))
               end
  end

  def aprroved_id_equal
    return if params.dig(:withdrawals, :aprroved_id).blank?

    @records = if records.is_a?(Class)
                 Withdrawal.where(value.query)
               else
                 records.or(Withdrawal.where('aprroved_id = ?', params.dig(:withdrawals, :aprroved_id)))
               end
  end

  def payment_method_id_equal
    return if params.dig(:withdrawals, :payment_method_id).blank?

    @records = if records.is_a?(Class)
                 Withdrawal.where(value.query)
               else
                 records.or(Withdrawal.where('payment_method_id = ?', params.dig(:withdrawals, :payment_method_id)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('withdrawals.created_at desc')
  end

  def paginate
    @records = Withdrawal.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
