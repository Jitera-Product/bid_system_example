json.message do
  json.extract! @message, :id, :chat_channel_id, :content, :created_at
end
json.status 200
