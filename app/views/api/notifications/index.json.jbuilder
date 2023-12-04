json.notifications do
  json.total @notifications.count
  json.total_categories @notifications.group_by(&:activity_type).count
  json.categories @notifications.group_by(&:activity_type) do |activity_type, notifications|
    json.set! activity_type do
      json.array! notifications do |notification|
        json.id notification.id
        json.created_at notification.created_at
        json.updated_at notification.updated_at
        json.activity_type notification.activity_type
        json.details notification.details
        json.status notification.status
        json.user_id notification.user_id
      end
    end
  end
end
