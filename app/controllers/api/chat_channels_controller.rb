module Api
  class ChatChannelsController < ApplicationController
    before_action :doorkeeper_authorize!

    def create
      bid_item_id = chat_channel_params[:bid_item_id]
      bid_item = BidItem.find_by(id: bid_item_id)

      if bid_item.nil? || !bid_item.status_ready?
        base_render_record_not_found
      else
        chat_channel = bid_item.chat_channels.create!(is_active: true)
        render json: { status: 201, chat_channel: ChatChannelSerializer.new(chat_channel).serializable_hash }, status: :created
      end
    rescue ActiveRecord::RecordInvalid => e
      base_render_unprocessable_entity(e)
    rescue Pundit::NotAuthorizedError
      base_render_unauthorized_error
    end

    def messages
      chat_channel_id = params[:id]
      chat_channel = ChatChannel.find_by(id: chat_channel_id, is_active: true)

      if chat_channel.nil?
        base_render_record_not_found("Chat channel not found.")
      else
        messages = chat_channel.messages.order(created_at: :asc)
        render json: {
          status: 200,
          messages: messages.as_json(only: [:id, :chat_channel_id, :user_id, :content, :created_at])
        }, status: :ok
      end
    end

    def check_chat_availability
      begin
        chat_channel_id = params[:id]
        raise ArgumentError, 'Chat channel ID must be provided and must be an integer.' unless chat_channel_id.present? && chat_channel_id.to_i.to_s == chat_channel_id

        bid_item = BidItem.find_by(id: chat_channel_id)
        raise ActiveRecord::RecordNotFound, 'Chat channel not found.' unless bid_item

        if bid_item.status_ready? && bid_item.chat_channels.any?(&:is_active)
          render json: { status: 200, chat_channel: { id: chat_channel_id, bid_item_id: bid_item.id, is_active: true } }, status: :ok
        else
          render json: { status: 200, chat_channel: { id: chat_channel_id, bid_item_id: bid_item.id, is_active: false } }, status: :ok
        end
      rescue ArgumentError => e
        render json: { error: e.message }, status: :bad_request
      rescue ActiveRecord::RecordNotFound => e
        render json: { error: e.message }, status: :not_found
      rescue => e
        render json: { error: e.message }, status: :internal_server_error
      end
    end

    private

    def chat_channel_params
      params.permit(:bid_item_id)
    end

    def current_user
      @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    # ... other private methods from existing code (if any)
  end
end
