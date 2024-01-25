# typed: ignore
module Api
  class MessagesController < BaseController
    before_action :authorize_create, only: [:create]
    before_action :validate_message_params, only: [:create]

    def create
      chat_channel_id = params[:chat_channel_id]
      user_id = params[:user_id]
      content = params[:content]

      # Check if the chat channel exists and is active
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      unless chat_channel&.active?
        render json: { error: "Chat channel not found or is not active." }, status: :unprocessable_entity and return
      end

      # Check if the user is a participant of the chat channel
      unless chat_channel.participants.exists?(user_id)
        render json: { error: "User does not have permission to access the resource." }, status: :forbidden and return
      end

      # Check if the chat channel has less than 30 messages
      if chat_channel.messages.count >= 30
        render json: { error: "Cannot send more than 30 messages per channel." }, status: :unprocessable_entity and return
      end

      begin
        message = MessageService.send_message(chat_channel_id, user_id, content)
        render json: { status: 201, message: message }, status: :created
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    private

    def validate_message_params
      unless params[:chat_channel_id].is_a?(Integer)
        render json: { error: "Chat channel ID must be provided and must be an integer." }, status: :bad_request and return
      end

      unless params[:user_id].is_a?(Integer)
        render json: { error: "User ID must be provided and must be an integer." }, status: :bad_request and return
      end

      content = params[:content]
      if content.nil? || content.length > 512
        render json: { error: "Message content must be provided and cannot exceed 512 characters." }, status: :bad_request and return
      end
    end

    def authorize_create
      authorize(:message, :create?)
    end
  end
end
