class NotificationSerializer < ActiveModel::Serializer
  attributes :id, :user_id, :activity_type, :details, :status
end
