json.status 200
json.chat_channel do
  json.id chat_channel.id
  json.bid_item_id chat_channel.bid_item_id
  json.created_at chat_channel.created_at
  json.is_active false
end
