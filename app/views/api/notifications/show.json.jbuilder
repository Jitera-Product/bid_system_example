json.notification do
  json.extract! @notification, :id, :user_id, :activity_type, :details, :status
end
