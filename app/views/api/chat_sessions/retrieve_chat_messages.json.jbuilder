
json.status 200
json.chat_messages @chat_messages, :id, :created_at, :message, :chat_session_id, :user_id

# If pagination is implemented, include the total messages and total pages
# This is a placeholder for pagination info, uncomment and adjust as needed
json.total_messages @total_messages if @total_messages.present?
json.total_pages @total_pages if @total_pages.present?

# Note: The instance variables @chat_messages, @total_messages, and @total_pages should be set in the controller action.
