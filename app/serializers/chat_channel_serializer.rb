
class ChatChannelSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :status

  # Define other necessary serializer fields and methods here
end
