# rubocop:disable Style/ClassAndModuleChildren
class ListingService::Index
  attr_accessor :params, :records, :query

  def initialize(params, _current_user = nil)
    @params = params
    @records = Listing
  end

  def execute
    description_start_with
    order
    paginate
  end

  private

  def description_start_with
    description_prefix = params.dig(:listings, :description)
    return if description_prefix.blank?

    # Use ILIKE for case-insensitive matching and ensure the wildcard is only at the end
    @records = @records.where('description ILIKE ?', "#{description_prefix}%")
  end

  def order
    # Check if @records is present before applying the order clause
    return unless @records.present?

    @records = @records.order('listings.created_at desc')
  end

  def paginate
    # Ensure that @records is not a Class object before calling pagination methods
    return if @records.blank? || @records.is_a?(Class)

    # Use provided pagination parameters with fallbacks to default values
    page = params.dig(:pagination, :page) || 1
    limit = params.dig(:pagination, :limit) || 20
    limit = [limit.to_i, 100].min # Ensure the limit does not exceed 100

    @records = @records.page(page).per(limit)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
