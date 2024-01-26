json.messages @messages do |message|
  json.id message.id
  json.chat_session_id message.chat_session_id
  json.user_id message.user_id
  json.content message.content
  json.created_at message.created_at.iso8601
end

# Assuming pagination is implemented with Kaminari
json.total_items @messages.total_count if @messages.respond_to?(:total_count)
json.total_pages @messages.total_pages if @messages.respond_to?(:total_pages)

# If pagination is not implemented, you can remove the above lines or adjust accordingly
# json.total_items @messages.size
# json.total_pages 1
