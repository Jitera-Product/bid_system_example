json.extract! @notification, :id, :activity_type, :details, :status, :created_at, :updated_at
json.user do
  json.extract! @notification.user, :id, :username, :email, :name
end
