json.status 200
json.notifications @notifications do |notification|
  json.id notification.id
  json.user_id notification.user_id
  json.activity_type notification.activity_type
  json.details notification.details
  json.status notification.status
end
