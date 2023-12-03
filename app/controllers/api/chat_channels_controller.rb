# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[reject_chat_request]
  # PUT /api/chat_channels/:id/reject
  def reject_chat_request
    chat_channel = ChatChannel.find_by(id: params[:id])
    return render json: { error: 'Chat channel not found' }, status: :bad_request unless chat_channel
    bid_item = chat_channel.bid_item
    return render json: { error: 'Forbidden' }, status: :forbidden unless current_user.id == bid_item.user_id
    return render json: { error: 'Chat channel is not active' }, status: :unprocessable_entity unless chat_channel.is_active
    if ChatChannelService.reject_request(chat_channel)
      chat_channel.update(is_active: false)
      render json: { status: 200, chat_channel: chat_channel.as_json(only: [:id, :bid_item_id, :user_id, :owner_id, :is_active]) }, status: :ok
    else
      render json: { error: 'Could not process the request' }, status: :unprocessable_entity
    end
  end
  # ... rest of the controller code ...
end
