# rubocop:disable Style/ClassAndModuleChildren
class BidService::Index
  attr_accessor :params, :records, :current_user

  def initialize(params, current_user = nil)
    @params = params
    @current_user = current_user
    @records = Bid.all
  end

  def execute
    filter_by_price
    filter_by_item_id
    filter_by_user_id
    filter_by_status
    apply_order
    paginate_results
  end

  private

  # Filters the records by price if the price parameter is provided.
  def filter_by_price
    return unless price_param

    @records = @records.where(price: price_param)
  end

  # Filters the records by item_id if the item_id parameter is provided.
  def filter_by_item_id
    return unless item_id_param

    @records = @records.where(item_id: item_id_param)
  end

  # Filters the records by user_id if the user_id parameter is provided.
  def filter_by_user_id
    return unless user_id_param

    @records = @records.where(user_id: user_id_param)
  end

  # Filters the records by status if the status parameter is provided.
  def filter_by_status
    return unless status_param

    @records = @records.where(status: status_param)
  end

  # Applies ordering to the records. Defaults to descending order by created_at.
  def apply_order
    return if @records.none?

    @records = @records.order(created_at: :desc)
  end

  # Paginates the records based on the provided pagination parameters.
  def paginate_results
    return if @records.none?

    page = params.dig(:pagination, :page) || 1
    limit = params.dig(:pagination, :limit) || 20
    @records = @records.page(page).per(limit)
  end

  # Retrieves the price parameter from the request parameters.
  def price_param
    params.dig(:bids, :price)
  end

  # Retrieves the item_id parameter from the request parameters.
  def item_id_param
    params.dig(:bids, :item_id)
  end

  # Retrieves the user_id parameter from the request parameters.
  def user_id_param
    params.dig(:bids, :user_id)
  end

  # Retrieves the status parameter from the request parameters.
  def status_param
    params.dig(:bids, :status)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
