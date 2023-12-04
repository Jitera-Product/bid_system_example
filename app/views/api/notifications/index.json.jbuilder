json.status 200
json.notifications @notifications do |notification|
  json.id notification.id
  json.user_id notification.user_id
  json.activity_type notification.activity_type
  json.details notification.details
  json.status notification.status
  json.created_at notification.created_at
  json.updated_at notification.updated_at
end
