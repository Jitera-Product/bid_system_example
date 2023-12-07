# rubocop:disable Style/ClassAndModuleChildren
class BidItemService::Index
  attr_accessor :params, :records, :query

  # Add NotFoundException and BadRequestException to the list of custom exceptions
  class NotFoundException < StandardError; end
  class BadRequestException < StandardError; end

  def initialize(params, _current_user = nil)
    @params = params

    @records = BidItem
  end

  def execute
    base_price_equal

    user_id_equal

    name_start_with

    expiration_time_equal

    product_id_equal

    status_equal

    order

    paginate
  end

  # New method to check the status of a bid item
  def check_bid_item_status(bid_item_id)
    bid_item = BidItem.find_by(id: bid_item_id)
    raise NotFoundException, "Bid item not found" unless bid_item

    case bid_item.status
    when 'open'
      bid_item.status
    when 'closed'
      raise BadRequestException, "Bid item already done"
    else
      bid_item.status
    end
  end

  # Existing methods below...

  def base_price_equal
    return if params.dig(:bid_items, :base_price).blank?

    @records = BidItem.where('base_price = ?', params.dig(:bid_items, :base_price))
  end

  def user_id_equal
    return if params.dig(:bid_items, :user_id).blank?

    @records = if records.is_a?(Class)
                 BidItem.where(value.query)
               else
                 records.or(BidItem.where('user_id = ?', params.dig(:bid_items, :user_id)))
               end
  end

  def name_start_with
    return if params.dig(:bid_items, :name).blank?

    @records = if records.is_a?(Class)
                 BidItem.where(value.query)
               else
                 records.or(BidItem.where('name like ?', "%#{params.dig(:bid_items, :name)}"))
               end
  end

  def expiration_time_equal
    return if params.dig(:bid_items, :expiration_time).blank?

    @records = if records.is_a?(Class)
                 BidItem.where(value.query)
               else
                 records.or(BidItem.where('expiration_time = ?', params.dig(:bid_items, :expiration_time)))
               end
  end

  def product_id_equal
    return if params.dig(:bid_items, :product_id).blank?

    @records = if records.is_a?(Class)
                 BidItem.where(value.query)
               else
                 records.or(BidItem.where('product_id = ?', params.dig(:bid_items, :product_id)))
               end
  end

  def status_equal
    return if params.dig(:bid_items, :status).blank?

    @records = if records.is_a?(Class)
                 BidItem.where(value.query)
               else
                 records.or(BidItem.where('status = ?', params.dig(:bid_items, :status)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('bid_items.created_at desc')
  end

  def paginate
    @records = BidItem.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
