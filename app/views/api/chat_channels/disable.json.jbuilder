json.status 200
json.chat_channel do
  json.id @chat_channel.id
  json.bid_item_id @chat_channel.bid_item_id
  json.is_active @chat_channel.is_active
  json.updated_at @chat_channel.updated_at.iso8601(3)
end
