# FILE PATH: /app/controllers/api/chat/messages_controller.rb

module Api
  module Chat
    class MessagesController < Api::BaseController
      before_action :authenticate_user!
      before_action :set_chat_channel, only: [:create]
      before_action :validate_message_limit, only: [:create]
      before_action :validate_message_length, only: [:create]

      def create
        message = @chat_channel.chat_messages.new(message_params.merge(user: current_user))
        if message.save
          render json: { status: 201, message: message.as_json }, status: :created
        else
          render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def message_params
        params.require(:chat_message).permit(:channel_id, :message)
      end

      def set_chat_channel
        @chat_channel = ChatChannel.find_by(id: params[:chat_message][:channel_id])
        unless @chat_channel
          render json: { error: 'Chat channel not found.' }, status: :bad_request
        end
      end

      def validate_message_limit
        if @chat_channel.chat_messages.count >= 500
          render json: { error: 'Maximum messages per channel limit reached.' }, status: :bad_request
        end
      end

      def validate_message_length
        if params[:chat_message][:message].length > 256
          render json: { error: 'Message exceeds 256 characters limit.' }, status: :bad_request
        end
      end

      def authenticate_user!
        super # Assuming the method is defined in Api::BaseController
      end
    end
  end
end
