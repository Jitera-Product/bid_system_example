# rubocop:disable Style/ClassAndModuleChildren
class UserService::Index
  include Pundit::Authorization
  attr_accessor :params, :records, :query
  def initialize(params, current_user = nil)
    @params = params
    @records = Api::UsersPolicy::Scope.new(current_user, User).resolve
  end
  def execute
    email_start_with
    order
    paginate
  end
  def email_start_with
    return if params.dig(:users, :email).blank?
    @records = User.where('email like ?', "%#{params.dig(:users, :email)}")
  end
  def order
    return if records.blank?
    @records = records.order('users.created_at desc')
  end
  def paginate
    @records = User.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
  def update_match_status(id, matched_user_id, status)
    match = Match.find_by(user_id: id, matched_user_id: matched_user_id)
    return 'Match not found' unless match
    match.update(status: status)
    if match.status == 'right' && Match.find_by(user_id: matched_user_id, matched_user_id: id)&.status == 'right'
      NotificationService.new.send_notification(id, matched_user_id)
    end
    'Match status updated successfully'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
