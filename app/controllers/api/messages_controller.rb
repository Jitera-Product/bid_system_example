# PATH: /app/controllers/api/messages_controller.rb
class Api::MessagesController < ApplicationController
  include AuthenticationConcern
  # ... (other actions in the controller)
  # POST /api/messages
  def create
    authorize MessagePolicy, :create?
    chat_channel_id = params[:chat_channel_id]
    content = params[:content]
    # Validate chat_channel_id and content
    chat_channel = ChatChannel.find_by(id: chat_channel_id, active: true)
    unless chat_channel
      return render json: { error: "Chat channel not found or not active." }, status: :bad_request
    end
    if content.length > 200
      return render json: { error: "You cannot input more than 200 characters." }, status: :bad_request
    end
    if chat_channel.messages.count >= 200
      return render json: { error: "Message limit reached for this chat channel." }, status: :bad_request
    end
    # Handle validation and creation of the message
    begin
      message = MessageCreationService.new.create_chat_message(chat_channel_id, current_user.id, content)
      render json: { status: 201, message: MessageSerializer.new(message).serialized_json }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: { error: e.message }, status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue Pundit::NotAuthorizedError => e
      render json: { error: e.message }, status: :forbidden
    end
  end
  # ... (other actions in the controller)
end
