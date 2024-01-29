class Api::ChatChannelsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: [:check_availability]

  def check_availability
    chat_channel = ChatChannel.find_by(id: params[:id])
    unless chat_channel
      return base_render_record_not_found('Chat channel not found.')
    end

    unless chat_channel.bid_item.status == 'active'
      raise Exceptions::ChatChannelNotActiveError, I18n.t('chat_channel_not_active')
    end

    if chat_channel.messages.count > 30
      raise Exceptions::ChatChannelNotActiveError, I18n.t('chat_channel_not_active')
    end

    render json: { status: 200, availability: true }
  rescue Exceptions::ChatChannelNotActiveError => e
    base_render_chat_channel_not_active(e)
  end

  private

  def base_render_chat_channel_not_active(exception)
    render json: { error: exception.message }, status: :forbidden
  end
end
