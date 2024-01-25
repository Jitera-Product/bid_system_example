json.status 201
json.chat_channel do
  json.id @chat_channel.id
  json.bid_item_id @chat_channel.bid_item_id
  json.status @chat_channel.status
  json.created_at @chat_channel.created_at.iso8601(3)
end
