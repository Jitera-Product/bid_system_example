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

  def description_start_with
    return if params.dig(:listings, :description).blank?

    @records = Listing.where('description like ?', "%#{params.dig(:listings, :description)}")
  end

  def order
    return if records.blank?

    @records = records.order('listings.created_at desc')
  end

  def paginate
    @records = Listing.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
end
# rubocop:enable Style/ClassAndModuleChildren
