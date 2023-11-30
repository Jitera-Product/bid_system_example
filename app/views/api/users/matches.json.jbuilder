json.matches @matches do |match|
  json.id match.id
  json.name match.user.name
  json.age match.user.age
  json.gender match.user.gender
  json.location match.user.location
  json.interests match.user.interests
  json.compatibility_score match.compatibility_score
end
