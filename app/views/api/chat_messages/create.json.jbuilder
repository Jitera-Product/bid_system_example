json.status 201
json.chat_message do
  json.id @chat_message.id
  json.created_at @chat_message.created_at.iso8601
  json.message @chat_message.message
  json.chat_session_id @chat_message.chat_session_id
  json.sender_id @chat_message.user_id
end
