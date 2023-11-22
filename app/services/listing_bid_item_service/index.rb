# rubocop:disable Style/ClassAndModuleChildren
class ListingBidItemService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params

    @records = ListingBidItem
  end

  def execute
    listing_id_equal

    bid_item_id_equal

    order

    paginate
  end

  def listing_id_equal
    return if params.dig(:listing_bid_items, :listing_id).blank?

    @records = ListingBidItem.where('listing_id = ?', params.dig(:listing_bid_items, :listing_id))
  end

  def bid_item_id_equal
    return if params.dig(:listing_bid_items, :bid_item_id).blank?

    @records = if records.is_a?(Class)
                 ListingBidItem.where(value.query)
               else
                 records.or(ListingBidItem.where('bid_item_id = ?', params.dig(:listing_bid_items, :bid_item_id)))
               end
  end

  def order
    return if records.blank?

    @records = records.order('listing_bid_items.created_at desc')
  end

  def paginate
    @records = ListingBidItem.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
