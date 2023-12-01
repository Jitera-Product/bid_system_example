module Api
  class MessagesController < BaseController
    before_action :authenticate_user!
    def create
      chat_channel_id = params[:chat_channel_id]
      content = params[:content]
      # Validate parameters
      if chat_channel_id.blank?
        render json: { message: 'Chat Channel ID is required' }, status: :bad_request
        return
      end
      if content.blank?
        render json: { message: 'The content is required.' }, status: :bad_request
        return
      end
      # Validate chat_channel_id format
      unless chat_channel_id.is_a?(Integer)
        render json: { message: 'Wrong format' }, status: :unprocessable_entity
        return
      end
      # Validate content length
      if content.length > 200
        render json: { message: 'You cannot input more 200 characters.' }, status: :unprocessable_entity
        return
      end
      # Validate chat channel existence and status
      chat_channel = ChatChannel.find_by(id: chat_channel_id)
      if chat_channel.nil?
        render json: { message: 'This chat channel is not found' }, status: :not_found
        return
      end
      if chat_channel.is_closed
        render json: { message: 'This chat channel is closed' }, status: :forbidden
        return
      end
      # Create a new message
      begin
        message = Message.create!(chat_channel_id: chat_channel_id, content: content)
        render json: { status: 200, message: message }, status: :ok
      rescue => e
        render json: { message: e.message }, status: :internal_server_error
      end
    end
    # ... rest of the code
  end
end
