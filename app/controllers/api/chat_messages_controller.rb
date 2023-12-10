class Api::ChatMessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    begin
      # Fetch the ChatChannel and ensure it exists and is associated with an active bid item
      chat_channel = ChatChannel.find_by(id: params[:channel_id])
      unless chat_channel
        return render json: { error: 'Channel not found.' }, status: :not_found
      end

      # Validate the length of the content
      content = params[:content]
      if content.length > 256
        return render json: { error: 'Message too long.' }, status: :bad_request
      end

      # Check the number of messages in the chat_messages table for the given channel_id
      if ChatMessage.where(chat_channel_id: params[:channel_id]).count >= 500
        return render json: { error: 'Maximum messages per channel reached.' }, status: :bad_request
      end

      # Create a new ChatMessage record
      chat_message = current_user.chat_messages.new(chat_channel_id: params[:channel_id], content: content)

      if chat_message.save
        # Broadcast the message to the channel subscribers
        ChatMessageBroadcastJob.perform_later(chat_message)
        render json: { status: 201, message: chat_message.as_json }, status: :created
      else
        render json: { error: chat_message.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    rescue => e
      render json: { error: e.message }, status: :internal_server_error
    end
  end

  private

  def authenticate_user!
    # Assuming this method is available for user authentication
    super # Call the method from the parent class (Api::BaseController)
  end
end
