# typed: ignore
module Api
  class MessagesController < BaseController
    before_action :authorize_create, only: [:create]

    def create
      chat_channel_id = params[:chat_channel_id]
      user_id = params[:user_id]
      content = params[:content]

      begin
        message_id = MessageService.send_message(chat_channel_id, user_id, content)
        render json: { message_id: message_id }, status: :created
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    private
    def authorize_create; authorize(:message, :create?); end
  end
end
