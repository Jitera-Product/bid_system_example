
json.status 'success'
json.total_count @messages.total_count

json.messages @messages do |message|
  json.extract! message, :id, :content, :created_at
  json.user do
    json.id message.user.id
    json.name message.user.name
  end
end
