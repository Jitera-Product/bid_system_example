class MessagesController < ApplicationController
  before_action :authenticate_user!
  def create
    sender_id = params[:sender_id]
    receiver_id = params[:receiver_id]
    content = params[:content]
    message = MessageService.new.create(sender_id, receiver_id, content)
    if message.persisted?
      NotificationService.new.send_notification(receiver_id)
      render json: { message: 'Message sent successfully' }, status: :ok
    else
      render json: { errors: message.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
