# PATH: /app/services/chat_channel_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class ChatChannelService::Index
  attr_accessor :params, :records, :query
  def initialize(params, _current_user = nil)
    @params = params
    @records = ChatChannel
  end
  def execute
    # existing code...
  end
  # New method to close a chat channel
  def close
    raise "Wrong format" unless params[:id].is_a?(Integer)
    chat_channel = ChatChannel.find_by(id: params[:id])
    raise "This chat channel is not found" if chat_channel.nil?
    chat_channel.update(is_closed: true)
    chat_channel
  end
  # existing methods...
end
# rubocop:enable Style/ClassAndModuleChildren
