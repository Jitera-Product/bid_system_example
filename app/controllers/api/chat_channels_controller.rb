# frozen_string_literal: true

module Api
  class ChatChannelsController < BaseController
    before_action :doorkeeper_authorize!
    before_action :set_chat_channel, only: [:disable]
    before_action :check_ownership, only: [:disable]

    def create
      bid_item = BidItem.find_by(id: chat_channel_params[:bid_item_id])

      if bid_item.nil?
        base_render_record_not_found
      elsif bid_item.status_done?
        render json: { message: 'Bid item is already completed.' }, status: :unprocessable_entity
      else
        chat_channel = bid_item.chat_channels.new(status: 'active')

        if chat_channel.save
          render 'api/chat_channels/create', status: :created, locals: { chat_channel: chat_channel }
        else
          base_render_unprocessable_entity(chat_channel)
        end
      end
    end

    def disable
      bid_item = @chat_channel.bid_item

      if bid_item.expiration_time.past? || bid_item.status_done?
        @chat_channel.update!(status: 'disabled', updated_at: Time.current)
        render 'api/chat_channels/disable', status: :ok
      else
        render json: { error: 'Bid item is not yet completed or expired.' }, status: :unprocessable_entity
      end
    end

    private

    def set_chat_channel
      @chat_channel = ChatChannel.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Chat channel not found.' }, status: :not_found
    end

    def check_ownership
      unless @chat_channel.bid_item.user == current_resource_owner
        render json: { error: 'User does not have permission to access the resource.' }, status: :forbidden
      end
    end

    def chat_channel_params
      params.require(:chat_channel).permit(:bid_item_id)
    end

    # Assuming base_render_record_not_found and base_render_unprocessable_entity are defined in BaseController
    # If not, they should be implemented or existing methods should be used.
  end
end
