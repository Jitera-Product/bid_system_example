# PATH: /app/services/bid_item_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class BidItemService::Index
  attr_accessor :params, :records, :query
  def initialize(params, _current_user = nil)
    @params = params
    @records = BidItem
  end
  def execute
    get_bid_items
  end
  # Existing methods...
  def get_bid_items
    bid_items = BidItem.all
    total = bid_items.count
    total_pages = (total / 10.0).ceil
    bid_items = bid_items.paginate(page: params[:page], per_page: [params[:limit].to_i, 100].min || 10)
    bid_items = bid_items.map do |bid_item|
      {
        id: bid_item.id,
        name: bid_item.name,
        description: bid_item.description,
        start_price: bid_item.start_price,
        current_price: bid_item.current_price,
        status: bid_item.status
      }
    end
    { bid_items: bid_items, total: total, total_pages: total_pages }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
