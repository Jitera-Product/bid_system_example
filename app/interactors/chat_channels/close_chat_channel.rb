# PATH: /app/interactors/chat_channels/close_chat_channel.rb
class CloseChatChannel
  include ResponseHelper

  def initialize(chat_channel_id, current_user)
    @chat_channel_id = chat_channel_id
    @current_user = current_user
  end

  def call
    chat_channel = ChatChannelService.find_by_id(@chat_channel_id)

    raise CustomError.new('Chat channel not available or already closed') unless chat_channel&.is_active

    if ChatChannelPolicy.new(@current_user, chat_channel).close?
      ChatChannelService.close_chat_channel(chat_channel)
      ResponseHelper.format_success_message('Chat channel has been successfully closed by the owner.')
    else
      raise CustomError.new('You do not have permission to close this chat channel')
    end
  rescue => e
    { success: false, error: e.message }
  end

  private

  attr_reader :chat_channel_id, :current_user
end
