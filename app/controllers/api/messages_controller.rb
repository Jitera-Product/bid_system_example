# frozen_string_literal: true

module Api
  class MessagesController < BaseController
    before_action :doorkeeper_authorize!
    before_action :set_chat_channel, only: [:index]
    before_action :authorize_chat_channel, only: [:index]

    def index
      messages = @chat_channel.messages.select(:id, :chat_channel_id, :user_id, :content, :created_at)
      render json: { status: 200, messages: messages }, status: :ok
    end

    private

    def set_chat_channel
      @chat_channel = ChatChannel.find(params[:chat_channel_id])
    rescue ActiveRecord::RecordNotFound
      base_render_record_not_found
    end

    def authorize_chat_channel
      authorize @chat_channel, :show?
    end
  end
end
