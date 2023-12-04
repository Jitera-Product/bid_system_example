json.total_items @total_items
json.total_pages @total_pages
json.bid_items @bid_items do |bid_item|
  json.id bid_item.id
  json.name bid_item.name
  json.description bid_item.description
  json.start_price bid_item.start_price
  json.current_price bid_item.current_price
  json.status bid_item.status
end
