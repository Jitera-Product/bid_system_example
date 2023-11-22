# rubocop:disable Style/ClassAndModuleChildren
class BidService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = Bid
  end

  def execute
    price_equal

    item_id_equal

    user_id_equal

    status_equal

    order

    paginate
  end

  def price_equal
    return if params.dig(:bids, :price).blank?

    @records = Bid.where('price = ?', params.dig(:bids, :price))
  end

  def item_id_equal
    return if params.dig(:bids, :item_id).blank?

    @records = if records.is_a?(Class)
                 Bid.where(value.query)
               else
                 records.or(Bid.where('item_id = ?', params.dig(:bids, :item_id)))
               end
  end

  def user_id_equal
    return if params.dig(:bids, :user_id).blank?

    @records = if records.is_a?(Class)
                 Bid.where(value.query)
               else
                 records.or(Bid.where('user_id = ?', params.dig(:bids, :user_id)))
               end
  end

  def status_equal
    return if params.dig(:bids, :status).blank?

    @records = if records.is_a?(Class)
                 Bid.where(value.query)
               else
                 records.or(Bid.where('status = ?', params.dig(:bids, :status)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('bids.created_at desc')
  end

  def paginate
    @records = Bid.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
