# FILE PATH: /app/controllers/api/chat/messages_controller.rb

module Api
  module Chat
    class MessagesController < Api::BaseController
      before_action :authenticate_user!
      
      def create
        chat_channel_id = params[:chat_channel_id]
        content = params[:content]
        
        # Validation for chat_channel_id existence
        unless ChatChannel.exists?(chat_channel_id)
          return render json: { error: 'Chat channel not found.' }, status: :bad_request
        end

        # Validation for content length
        if content.length > 256
          return render json: { error: 'You cannot input more than 256 characters.' }, status: :bad_request
        end

        # Validation for maximum messages in a chat channel
        if ChatMessage.where(chat_channel_id: chat_channel_id).count >= 500
          return render json: { error: 'Maximum messages per channel is 500.' }, status: :bad_request
        end
        
        # Authorization check (assuming there's a ChatPolicy defined)
        authorize chat_channel_id, :send_message?
        
        result = ChatService.send_chat_message(current_user.id, chat_channel_id, content)
        
        if result[:success]
          render json: { status: 201, chat_message: result[:chat_message] }, status: :created
        else
          render_error(result[:message])
        end
      rescue Pundit::NotAuthorizedError
        render json: { error: 'Forbidden' }, status: :forbidden
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Chat channel not found.' }, status: :not_found
      rescue StandardError => e
        render json: { error: e.message }, status: :internal_server_error
      end

      private

      def render_error(message)
        case message
        when 'User must be logged in.'
          render json: { error: message }, status: :unauthorized
        when 'Chat channel not found.', 'You cannot input more than 256 characters.', 'Maximum messages per channel is 500.'
          render json: { error: message }, status: :bad_request
        else
          render json: { error: message }, status: :unprocessable_entity
        end
      end
    end
  end
end
