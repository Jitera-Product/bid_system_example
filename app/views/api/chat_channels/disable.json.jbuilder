json.status 200
json.chat_channel do
  json.id @chat_channel.id
  json.status @chat_channel.status
  json.updated_at @chat_channel.updated_at.iso8601(3)
end
