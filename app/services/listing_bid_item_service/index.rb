# rubocop:disable Style/ClassAndModuleChildren
class ListingBidItemService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = ListingBidItem.all
  end

  def execute
    listing_id_equal
    bid_item_id_equal
    order
    paginate
  end

  private

  def listing_id_equal
    listing_id = params.dig(:listing_bid_items, :listing_id)
    @records = records.where(listing_id: listing_id) if listing_id.present?
  end

  def bid_item_id_equal
    bid_item_id = params.dig(:listing_bid_items, :bid_item_id)
    @records = records.where(bid_item_id: bid_item_id) if bid_item_id.present?
  end

  def order
    @records = records.order(created_at: :desc)
  end

  def paginate
    page = params.dig(:pagination, :page) || 1
    limit = params.dig(:pagination, :limit) || 20
    @records = records.page(page).per(limit)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
