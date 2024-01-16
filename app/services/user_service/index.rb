
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

  def update_user_role(target_user_id, new_role, admin_id)
    target_user = User.find_by(id: target_user_id)
    admin_user = User.find_by(id: admin_id)

    return 'Admin user not found or not an admin' unless admin_user&.admin?
    return 'Target user not found' unless target_user
    return 'Invalid role' unless User.roles.keys.include?(new_role)

    target_user.role = new_role
    if target_user.save
      'User role updated successfully'
    else
      'Failed to update user role'
    end
  end

end
# rubocop:enable Style/ClassAndModuleChildren
