# /app/interactors/chat_channels/close_channel.rb
class CloseChannel
  include Interactor
  def initialize(chat_channel_id:, owner_id:)
    @chat_channel_id = chat_channel_id
    @owner_id = owner_id
  end
  def call
    user = User.find_by(id: @owner_id)
    chat_channel = ChatChannel.find_by(id: @chat_channel_id)
    unless user && chat_channel
      context.fail!(error: "Invalid user or chat channel.")
    end
    unless ChatChannelPolicy.new(user, chat_channel).owner?
      context.fail!(error: "User is not the owner of the chat channel.")
    end
    chat_channel.update!(is_active: false)
    context.chat_channel = { chat_channel_id: chat_channel.id, is_active: chat_channel.is_active }
  rescue ActiveRecord::RecordNotFound => e
    context.fail!(error: e.message)
  rescue StandardError => e
    context.fail!(error: "An unexpected error occurred: #{e.message}")
  end
end
