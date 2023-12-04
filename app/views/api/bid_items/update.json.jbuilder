json.bid_item do
  json.id @bid_item.id
  json.name @bid_item.name
  json.description @bid_item.description
  json.start_price @bid_item.start_price
  json.current_price @bid_item.current_price
  json.status @bid_item.status
end
