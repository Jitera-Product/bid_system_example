json.chat_channel do
  if @chat_channel.errors.any?
    json.status 400
    json.errors @chat_channel.errors.full_messages
  else
    json.extract! @chat_channel, :id, :user_id, :bid_item_id, :is_closed
    json.status 200
  end
end
