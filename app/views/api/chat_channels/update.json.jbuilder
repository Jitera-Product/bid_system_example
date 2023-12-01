json.chat_channel do
  json.extract! @chat_channel, :id, :user_id, :bid_item_id, :is_closed
end
