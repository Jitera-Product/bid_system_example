# rubocop:disable Style/ClassAndModuleChildren
class ShippingService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Shipping
  end

  def execute
    shipping_address_start_with

    post_code_equal

    phone_number_start_with

    bid_id_equal

    status_equal

    full_name_start_with

    email_start_with

    order

    paginate
  end

  def shipping_address_start_with
    return if params[:shipping_address].blank?

    @records = records.where('shipping_address ILIKE ?', "#{params[:shipping_address]}%")
  end

  def post_code_equal
    return if params[:post_code].blank?

    @records = records.where(post_code: params[:post_code])
  end

  def phone_number_start_with
    return if params[:phone_number].blank?

    @records = records.where('phone_number ILIKE ?', "#{params[:phone_number]}%")
  end

  def bid_id_equal
    return if params[:bid_id].blank?

    @records = records.where(bid_id: params[:bid_id])
  end

  def status_equal
    return if params[:status].blank?

    @records = records.where(status: params[:status])
  end

  def full_name_start_with
    return if params[:full_name].blank?

    @records = records.where('full_name ILIKE ?', "#{params[:full_name]}%")
  end

  def email_start_with
    return if params[:email].blank?

    @records = records.where('email ILIKE ?', "#{params[:email]}%")
  end

  def order
    @records = records.order(created_at: :desc)
  end

  def paginate
    page = params.fetch(:page, 1).to_i
    limit = params.fetch(:limit, 10).to_i.clamp(1, 100) # Ensuring the limit is within a reasonable range
    @records = records.page(page).per(limit)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
