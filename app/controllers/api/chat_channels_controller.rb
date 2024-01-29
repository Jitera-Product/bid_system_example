module Api
  class ChatChannelsController < ApplicationController
    before_action :doorkeeper_authorize!, only: [:create, :disable]
    before_action :set_chat_channel, only: [:disable, :messages]
    before_action :validate_bid_item, only: [:disable]
    before_action :authorize_disable, only: [:disable]

    # POST /api/chat_channels
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

    # PUT /api/chat_channels/:id/disable
    def disable
      if @bid_item.status_done?
        @chat_channel.update!(is_active: false)
        render json: {
          status: 200,
          chat_channel: {
            id: @chat_channel.id,
            bid_item_id: @chat_channel.bid_item_id,
            is_active: @chat_channel.is_active,
            updated_at: @chat_channel.updated_at
          }
        }, status: :ok
      else
        render json: { message: 'Bid item is not done.' }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    # GET /api/chat_channels/:id/messages
    def messages
      if @chat_channel.nil? || !@chat_channel.is_active
        base_render_record_not_found("Chat channel not found.")
      else
        messages = @chat_channel.messages.order(created_at: :asc)
        render json: {
          status: 200,
          messages: messages.as_json(only: [:id, :chat_channel_id, :user_id, :content, :created_at])
        }, status: :ok
      end
    end

    # GET /api/chat_channels/:id/check_availability
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

    def set_chat_channel
      @chat_channel = ChatChannel.find_by(id: params[:id])
    end

    def validate_bid_item
      @bid_item = @chat_channel.bid_item if @chat_channel
      raise ActiveRecord::RecordNotFound unless @bid_item && BidItem.exists?(id: @bid_item.id)
    end

    def authorize_disable
      authorize @chat_channel.bid_item, :disable? if @chat_channel
    end

    def chat_channel_params
      params.permit(:bid_item_id)
    end

    def current_user
      @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    # ... other private methods from existing code (if any)
  end
end
