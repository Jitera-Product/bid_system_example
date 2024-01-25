json.status @chat_availability_status
json.availability do
  json.chat_channel_id @chat_channel_id
  json.is_available @is_available
end
