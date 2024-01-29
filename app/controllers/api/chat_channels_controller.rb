module Api
  class ChatChannelsController < BaseController
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

    private

    def chat_channel_params
      params.permit(:bid_item_id)
    end
  end
end
