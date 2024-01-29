class Api::MessagesController < Api::BaseController
  before_action :doorkeeper_authorize!

  def create
    chat_channel = ChatChannel.find_by(id: message_params[:chat_channel_id])
    return render json: { error: I18n.t('common.404'), message: 'Chat channel not found.' }, status: :not_found if chat_channel.nil?
    return render json: { error: I18n.t('common.403'), message: 'Chat channel is not active.' }, status: :forbidden unless chat_channel.is_active
    return render json: { error: I18n.t('common.403'), message: 'User not found.' }, status: :forbidden unless User.exists?(message_params[:user_id])
    return render json: { error: I18n.t('common.403'), message: 'User does not have permission to access the resource.' }, status: :forbidden unless policy(chat_channel).send_message?

    message = chat_channel.messages.build(message_params)

    if message.save
      render json: { status: I18n.t('common.201'), message: message.as_json }, status: :created
    else
      render json: { error: I18n.t('common.422'), message: message.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:chat_channel_id, :user_id, :content)
  end
end
