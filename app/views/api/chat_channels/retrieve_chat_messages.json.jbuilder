def index
  @messages = Message.page(params[:page]).per(params[:per_page])

  json.current_page @messages.current_page
  json.total_pages @messages.total_pages

  json.status 200
  json.total_count @messages.total_count

  json.messages @messages do |message|
    json.id message.id
    json.chat_channel_id message.chat_channel_id
    json.user_id message.user_id
    json.content message.content
    json.created_at message.created_at.iso8601
    json.user do
      json.id message.user.id
      json.name message.user.name
    end
  end
end
