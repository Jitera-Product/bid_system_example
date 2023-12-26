module Bids
  class ListService < BaseService
    attr_reader :params

    def initialize(params)
      @params = params
    end

    def call
      bids_query = BidsQuery.new
      filtered_bids = bids_query
                          .by_price(params[:price])
                          .by_item_id(params[:item_id])
                          .by_user_id(params[:user_id])
                          .by_status(params[:status])
                          .order(created_at: :desc)

      paginated_bids = Pagination.paginate(filtered_bids, params)

      {
        records: paginated_bids.records,
        pagination: {
          current_page: paginated_bids.current_page,
          total_pages: paginated_bids.total_pages,
          total_count: paginated_bids.total_count
        }
      }
    rescue StandardError => e
      { error: e.message }
    end
  end
end
