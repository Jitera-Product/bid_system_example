class ChatChannelsController < ApplicationController
  # ... other necessary code for controller ...

  def create
    @chat_channel = ChatChannel.new(chat_channel_params)
    if @chat_channel.save
      render json: Jbuilder.encode { |json|
        json.status 201
        json.chat_channel do
          json.id @chat_channel.id
          json.bid_item_id @chat_channel.bid_item_id
          json.created_at @chat_channel.created_at.iso8601(3) # Use the more precise timestamp from the existing code
          json.is_active @chat_channel.is_active
        end
      }, status: :created
    else
      # ... handle save errors ...
    end
  end

  # ... other necessary code for controller ...

  private

  def chat_channel_params
    # ... params handling ...
  end
end
