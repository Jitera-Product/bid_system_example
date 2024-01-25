class MessageSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at

  belongs_to :user, serializer: UserSerializer
  belongs_to :chat_channel, serializer: ChatChannelSerializer

  def user
    object.user.slice(:id, :name, :email)
  end

  def chat_channel
    object.chat_channel.slice(:id, :status)
  end
end

