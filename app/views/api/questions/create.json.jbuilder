if @question.errors.any?
  json.errors @question.errors.full_messages
else
  json.id @question.id
  json.content @question.content
  json.user_id @question.user_id
  json.category @question.category
end
