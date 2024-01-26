json.status 200
json.chat_messages @chat_messages do |chat_message|
  json.id chat_message.id
  json.created_at chat_message.created_at
  json.message chat_message.message
  json.chat_session_id chat_message.chat_session_id
  json.sender_id chat_message.user_id
end

# If pagination is implemented, include the total messages and total pages
# This is a placeholder for pagination info, uncomment and adjust as needed
# json.total_messages @total_messages
# json.total_pages @total_pages

# Note: The instance variables @chat_messages, @total_messages, and @total_pages should be set in the controller action.
