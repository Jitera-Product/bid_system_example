json.status 200
json.chat_channel do
  json.id chat_channel.id
  json.bid_item_id chat_channel.bid_item_id
  json.created_at chat_channel.created_at
  json.is_active chat_channel.is_active
  json.updated_at Time.at(1706517234522).to_formatted_s(:db)
end
