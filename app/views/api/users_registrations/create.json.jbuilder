json.status 200
json.user do
  json.id @user.id
  json.name @user.name
  json.age @user.age
  json.gender @user.gender
  json.location @user.location
  json.interests @user.interests
  json.preferences @user.preferences
end
