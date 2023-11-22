# rubocop:disable Style/ClassAndModuleChildren
class ShippingService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Shipping
  end

  def execute
    shiping_address_start_with

    post_code_equal

    phone_number_start_with

    bid_id_equal

    status_equal

    full_name_start_with

    email_start_with

    order

    paginate
  end

  def shiping_address_start_with
    return if params.dig(:shippings, :shiping_address).blank?

    @records = Shipping.where('shiping_address like ?', "%#{params.dig(:shippings, :shiping_address)}")
  end

  def post_code_equal
    return if params.dig(:shippings, :post_code).blank?

    @records = if records.is_a?(Class)
                 Shipping.where(value.query)
               else
                 records.or(Shipping.where('post_code = ?', params.dig(:shippings, :post_code)))
               end
  end

  def phone_number_start_with
    return if params.dig(:shippings, :phone_number).blank?

    @records = if records.is_a?(Class)
                 Shipping.where(value.query)
               else
                 records.or(Shipping.where('phone_number like ?', "%#{params.dig(:shippings, :phone_number)}"))
               end
  end

  def bid_id_equal
    return if params.dig(:shippings, :bid_id).blank?

    @records = if records.is_a?(Class)
                 Shipping.where(value.query)
               else
                 records.or(Shipping.where('bid_id = ?', params.dig(:shippings, :bid_id)))
               end
  end

  def status_equal
    return if params.dig(:shippings, :status).blank?

    @records = if records.is_a?(Class)
                 Shipping.where(value.query)
               else
                 records.or(Shipping.where('status = ?', params.dig(:shippings, :status)))
               end
  end

  def full_name_start_with
    return if params.dig(:shippings, :full_name).blank?

    @records = if records.is_a?(Class)
                 Shipping.where(value.query)
               else
                 records.or(Shipping.where('full_name like ?', "%#{params.dig(:shippings, :full_name)}"))
               end
  end

  def email_start_with
    return if params.dig(:shippings, :email).blank?

    @records = if records.is_a?(Class)
                 Shipping.where(value.query)
               else
                 records.or(Shipping.where('email like ?', "%#{params.dig(:shippings, :email)}"))
               end
  end

  def order
    return if records.blank?

    @records = records.order('shippings.created_at desc')
  end

  def paginate
    @records = Shipping.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
