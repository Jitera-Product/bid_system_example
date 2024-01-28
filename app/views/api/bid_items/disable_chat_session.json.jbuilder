
json.status 200
json.chat_session do
  json.id @chat_session.id
  json.updated_at @chat_session.updated_at
  json.is_active @chat_session.is_active
  json.bid_item_id @chat_session.bid_item_id
end
