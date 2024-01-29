
class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    chat_channel = ChatChannel.find_by(id: message_params[:chat_channel_id])
    if chat_channel.nil? || !chat_channel.is_active
      error_message = chat_channel.nil? ? I18n.t('common.404') : I18n.t('common.chat_channel_not_active')
      return render json: { error: error_message }, status: :forbidden
    end

    return render json: { error: I18n.t('common.403'), message: 'User not found.' }, status: :forbidden unless User.exists?(message_params[:sender_id])
    unless policy(chat_channel).send_message?
      return render json: { error: I18n.t('common.403'), message: 'User does not have permission to access the resource.' }, status: :forbidden
    end
    
    message = chat_channel.messages.build(message_params)

    if chat_channel.messages.count >= 100
      raise Exceptions::ChatChannelNotActiveError, I18n.t('common.chat_channel_not_active')
    end

    if chat_channel.message_count >= 30
      raise Exceptions::ChatChannelNotActiveError, I18n.t('common.chat_channel_message_limit_reached')
    end

    if message.save
      chat_channel.increment!(:message_count)
      message.update(created_at: Time.current, updated_at: Time.current)
      @message = message
      render 'create', status: :created
    else
      render json: { error: I18n.t('common.422'), message: message.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:chat_channel_id, :sender_id, :content)
  end

  rescue_from Exceptions::ChatChannelNotActiveError do |e|
    render json: { error: e.message }, status: :forbidden
  end
end
