json.status '201'
json.chat_session do
  json.id @chat_session.id
  json.created_at @chat_session.created_at
  json.is_active @chat_session.is_active
  json.bid_item_id @chat_session.bid_item_id
end
