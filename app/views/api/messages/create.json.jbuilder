json.id @message.id
json.chat_channel_id @message.chat_channel_id
json.sender_id @message.sender_id
json.content @message.content
json.created_at @message.created_at.strftime('%Y-%m-%dT%H:%M:%S.%LZ') # Assuming the provided timestamp format is ISO 8601 with milliseconds
