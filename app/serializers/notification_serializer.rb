class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :activity_type, :details, :status, :created_at, :updated_at
  belongs_to :user, serializer: UserSerializer
end
