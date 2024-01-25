# frozen_string_literal: true

module Api
  class ChatChannelsController < BaseController
    before_action :doorkeeper_authorize!

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

    private

    def chat_channel_params
      params.require(:chat_channel).permit(:bid_item_id)
    end
  end
end
