# rubocop:disable Style/ClassAndModuleChildren
class ListingBidItemService::Index
  attr_accessor :params, :records
  def initialize(params)
    @params = params
    @records = ListingBidItem
  end
  def execute
    paginate
  end
  def paginate
    page = params.dig(:page) || 1
    limit = params.dig(:limit) || 20
    @records = ListingBidItem.page(page).per(limit)
  end
  def response
    {
      listing_bid_items: @records,
      total_items: @records.total_count,
      total_pages: @records.total_pages
    }
  end
end
# rubocop:enable Style/ClassAndModuleChildren
