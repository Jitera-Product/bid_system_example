json.status 200
json.messages @messages do |message|
  json.id message.id
  json.chat_channel_id message.chat_channel_id
  json.sender_user_id message.user_id
  json.content message.content
  json.created_at message.created_at.iso8601
end
