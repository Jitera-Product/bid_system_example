# typed: true
class BaseService
  def initialize(*_args); end

  def logger
    @logger ||= Rails.logger
  end
end

class ChatMessageFetchService < BaseService
  def initialize(chat_channel_id)
    @chat_channel_id = chat_channel_id
  end

  def call
    chat_messages = []
    begin
      chat_messages = ChatMessage.where(chat_channel_id: @chat_channel_id)
                                 .order(:created_at)
                                 .select(:id, :content, :created_at, :user_id)
    rescue StandardError => e
      logger.error "ChatMessageFetchService encountered an error: #{e.message}"
    end
    chat_messages
  end
end
