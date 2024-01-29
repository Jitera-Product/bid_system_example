class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    chat_channel = ChatChannel.find_by(id: message_params[:chat_channel_id])
    if chat_channel.nil? || !chat_channel.is_active
      error_message = chat_channel.nil? ? I18n.t('common.404') : I18n.t('chat_channel.chat_channel_not_active')
      return render json: { error: error_message }, status: :forbidden
    end

    # The new code checks for User existence using :user_id, while the existing code uses :sender_id.
    # We need to support both, assuming they are meant to be the same.
    user_id = message_params[:user_id] || message_params[:sender_id]
    return render json: { error: I18n.t('common.403'), message: 'User not found.' }, status: :forbidden unless User.exists?(user_id)

    # The new code has an additional policy check for allowed_to_send_message?
    # We need to include this check as well.
    unless policy(chat_channel).allowed_to_send_message?
      return base_render_unauthorized_error
    end

    unless policy(chat_channel).send_message?
      return render json: { error: I18n.t('common.403'), message: 'User does not have permission to access the resource.' }, status: :forbidden
    end
    
    message = chat_channel.messages.build(message_params)

    # The new code has a limit of 100 messages, while the existing code has a limit of 30.
    # We need to reconcile these limits. Assuming the stricter limit (30) should be enforced.
    if chat_channel.messages.count >= 30
      raise Exceptions::ChatChannelNotActiveError, I18n.t('common.chat_channel_message_limit_reached')
    end

    if message.save
      # The existing code increments the message_count and updates timestamps.
      # We need to keep this behavior.
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
    # The new code uses :user_id, while the existing code uses :sender_id.
    # We need to support both, assuming they are meant to be the same.
    params.require(:message).permit(:chat_channel_id, :user_id, :sender_id, :content)
  end

  def base_render_unauthorized_error
    render json: { error: I18n.t('common.403'), message: 'User does not have permission to access the resource.' }, status: :forbidden
  end

  rescue_from Exceptions::ChatChannelNotActiveError do |e|
    render json: { error: e.message }, status: :forbidden
  end
end
