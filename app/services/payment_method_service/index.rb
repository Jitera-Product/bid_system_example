# rubocop:disable Style/ClassAndModuleChildren
class PaymentMethodService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = PaymentMethod
  end

  def execute
    user_id_equal

    primary_equal

    method_equal

    order

    paginate
  end

  def user_id_equal
    return if params.dig(:wallets, :user_id).blank?

    @records = PaymentMethod.where('user_id = ?', params.dig(:wallets, :user_id))
  end

  def primary_equal
    return if params.dig(:wallets, :primary).blank?

    @records = if records.is_a?(Class)
                 PaymentMethod.where(value.query)
               else
                 records.or(PaymentMethod.where('primary = ?', params.dig(:wallets, :primary)))
               end
  end

  def method_equal
    return if params.dig(:wallets, :method).blank?

    @records = if records.is_a?(Class)
                 PaymentMethod.where(value.query)
               else
                 records.or(PaymentMethod.where('method = ?', params.dig(:wallets, :method)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('payment_methods.created_at desc')
  end

  def paginate
    @records = PaymentMethod.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
