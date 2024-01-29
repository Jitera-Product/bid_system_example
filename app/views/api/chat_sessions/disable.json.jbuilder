json.status 200
json.chat_session do
  json.id @chat_session.id
  json.is_active @chat_session.is_active
  json.updated_at @chat_session.updated_at.iso8601(3)
end
