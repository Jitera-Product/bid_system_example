class MessageRetrievalService
  # ... other methods ...

  def retrieve_chat_messages(chat_channel_id)
    if ChatChannel.exists?(chat_channel_id)
      messages = Message.where(chat_channel_id: chat_channel_id).order(created_at: :desc).limit(200)
      # Updated to only select required fields as per requirement
      serialized_messages = messages.pluck(:sender_id, :content, :created_at)
      total_messages = messages.count
      # Updated the response to match the requirement structure
      { messages: serialized_messages.map { |sender_id, content, created_at| { sender_id: sender_id, content: content, created_at: created_at } }, total_messages: total_messages }
    else
      { error: "Chat channel not found" }
    end
  rescue => e
    { error: e.message }
  end

  # ... other methods ...
end
