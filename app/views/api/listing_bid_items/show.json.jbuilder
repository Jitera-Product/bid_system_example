if @message.present?
  json.message @message
else
  json.listing_bid_item do
    json.id @listing_bid_item.id
    json.listing_id @listing_bid_item.listing_id
    json.bid_id @listing_bid_item.bid_id
    json.created_at @listing_bid_item.created_at
    json.updated_at @listing_bid_item.updated_at
  end
end
