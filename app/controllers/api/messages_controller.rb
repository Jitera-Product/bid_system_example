# /app/controllers/api/messages_controller.rb

class Api::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
    return render json: { error: 'Chat channel not found' }, status: :not_found unless chat_channel

    # Ensure the chat channel is associated with the user's bid item
    authorize chat_channel, :create_message?

    return render json: { error: 'User must be logged in' }, status: :unauthorized unless current_user

    content = params[:content]
    if content.length > 256
      return render json: { error: 'You cannot input more than 256 characters.' }, status: :bad_request
    end

    if chat_channel.messages.count >= 500
      return render json: { error: 'Maximum messages per channel is 500.' }, status: :bad_request
    end

    message = chat_channel.messages.new(content: content, user_id: current_user.id)

    if message.save
      render json: { status: 201, message: message.as_json }, status: :created
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_user!
    # Assuming there's a method to authenticate the user
    # This should set the current_user if successful
    render json: { error: 'Not Authenticated' }, status: :unauthorized unless current_user.present?
  end
end
