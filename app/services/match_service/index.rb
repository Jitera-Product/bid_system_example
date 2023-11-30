# PATH: /app/services/match_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class MatchService::Index
  attr_accessor :user_id
  def initialize(user_id)
    @user_id = user_id
  end
  def execute
    user = User.find(user_id)
    potential_matches = User.where.not(id: user_id)
    matches = potential_matches.map do |potential_match|
      compatibility_score = calculate_compatibility_score(user, potential_match)
      Match.create(user_id: user_id, match_id: potential_match.id, compatibility_score: compatibility_score)
    end
    matches
  end
  def update_match_status(match_id, action)
    match = Match.find_by(user_id: user_id, id: match_id)
    return { error: 'Match not found', status: 404 } unless match
    return { error: 'Invalid action type.', status: 422 } unless ['like', 'pass'].include?(action)
    match.update(status: action)
    if action == 'like' && match.matched_user.matches.find_by(user_id: match.matched_user_id, status: 'like')
      # Send notification to both users
      NotificationService.new(user_id, "You have a new match!").send
      NotificationService.new(match.matched_user_id, "You have a new match!").send
    end
    { message: 'Match status updated successfully', match: match, status: 200 }
  end
  private
  def calculate_compatibility_score(user, potential_match)
    common_interests = (user.interests & potential_match.interests).count
    total_interests = (user.interests | potential_match.interests).count
    common_interests.to_f / total_interests
  end
end
# rubocop:enable Style/ClassAndModuleChildren
