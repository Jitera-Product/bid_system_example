
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

  def update_user_role(user_id, new_role)
    user = User.find(user_id)
    raise ActiveRecord::RecordNotFound unless user

    authorize User, :update?

    if User.valid_role?(new_role)
      user.role = new_role
      user.save!
      # Log the role change action
      # This is a placeholder for the logging mechanism
      # Replace with actual logging code as per project standards
      Rails.logger.info "User role updated: user_id=#{user_id}, new_role=#{new_role}"
    else
      raise ArgumentError, 'Invalid role'
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
