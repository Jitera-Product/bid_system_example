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
  private
  def calculate_compatibility_score(user, potential_match)
    # This is a placeholder for the matching algorithm. You may need to replace it with a real algorithm.
    common_interests = (user.interests & potential_match.interests).count
    total_interests = (user.interests | potential_match.interests).count
    common_interests.to_f / total_interests
  end
end
# rubocop:enable Style/ClassAndModuleChildren
