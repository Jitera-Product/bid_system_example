# frozen_string_literal: true

class ChatChannelSerializer
  include JSONAPI::Serializer

  set_type :chat_channel
  attributes :id, :bid_item_id, :created_at, :is_active

  # Define any custom serializer methods or options here
end

