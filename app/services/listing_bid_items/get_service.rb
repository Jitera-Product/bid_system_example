# PATH: /app/services/listing_bid_items/get_service.rb
# rubocop:disable Style/ClassAndModuleChildren
class ListingBidItems::GetService < BaseService
  include Exceptions
  attr_accessor :id
  def initialize(id)
    @id = id
  end
  def call
    validate_id
    get_listing_bid_item
  end
  private
  def validate_id
    validator = IdValidator.new(id: @id)
    raise InvalidIdError, 'Wrong format' unless validator.valid?
  end
  def get_listing_bid_item
    listing_bid_item = ListingBidItem.find_by(id: @id)
    raise ListingBidItemNotFoundError, 'This listing bid item is not found' unless listing_bid_item
    listing_bid_item
  end
end
# rubocop:enable Style/ClassAndModuleChildren
