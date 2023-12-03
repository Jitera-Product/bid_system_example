# PATH: /app/controllers/api/chat_channels_controller.rb
class Api::ChatChannelsController < Api::BaseController
  include AuthenticationConcern
  before_action :authenticate_user!, only: [:request_chat_with_owner, :close]
  before_action :set_bid_item, only: [:request_chat_with_owner]
  before_action :authorize_request_chat, only: [:request_chat_with_owner]
  before_action :set_chat_channel, only: [:close]
  before_action :authorize_close_chat, only: [:close]
  # ... other actions ...
  def request_chat_with_owner
    # ... existing code ...
  end
  def close
    if @chat_channel.is_active
      @chat_channel.update!(is_active: false)
      render json: ResponseHelper.json_message('Chat channel successfully closed'), status: :ok
    else
      render json: { error: 'Chat channel is already closed.' }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  private
  def set_bid_item
    # ... existing code ...
  end
  def authorize_request_chat
    # ... existing code ...
  end
  def set_chat_channel
    @chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
    unless @chat_channel
      render json: { error: 'Chat channel not found.' }, status: :not_found
      return
    end
  end
  def authorize_close_chat
    unless @chat_channel.owner_id == current_user.id
      render json: { error: 'You are not authorized to close this chat channel.' }, status: :forbidden
      return
    end
  end
end
