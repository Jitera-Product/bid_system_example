# frozen_string_literal: true

module Api
  class MessagesController < BaseController
    before_action :doorkeeper_authorize!
    before_action :set_chat_channel, only: [:index, :create]
    before_action :authorize_chat_channel, only: [:index]

    def index
      messages = @chat_channel.messages.select(:id, :chat_channel_id, :user_id, :content, :created_at)
      render json: { status: 200, messages: messages }, status: :ok
    end

    def create
      content = params[:content]

      return render json: { error: "Message content is required." }, status: :bad_request if content.blank?
      return render json: { error: "You cannot input more than 512 characters." }, status: :unprocessable_entity if content.length > 512
      return render json: { error: "Chat is disabled." }, status: :forbidden unless @chat_channel.status == 'active'

      sender_user_id = current_resource_owner.id
      return render json: { error: "User does not have permission to access the resource." }, status: :forbidden unless user_involved_in_bid_item?(sender_user_id, @chat_channel.bid_item_id)

      messages_count = @chat_channel.messages.count
      return render json: { error: "Cannot send more than 30 messages per channel." }, status: :forbidden if messages_count >= 30

      message = @chat_channel.messages.create(user_id: sender_user_id, content: content)

      if message.persisted?
        @chat_channel.touch(:updated_at)
        render json: {
          status: 201,
          message: {
            id: message.id,
            chat_channel_id: message.chat_channel_id,
            sender_user_id: message.user_id,
            content: message.content,
            created_at: message.created_at.iso8601
          }
        }, status: :created
      else
        render json: { error: message.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    end

    private

    def set_chat_channel
      @chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
      return render json: { error: "Chat channel not found." }, status: :not_found unless @chat_channel
    end

    def authorize_chat_channel
      authorize @chat_channel, :show?
    end
  end
end
