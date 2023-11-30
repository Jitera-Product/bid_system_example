# PATH: /app/services/admin_service/index.rb
# rubocop:disable Style/ClassAndModuleChildren
class AdminService::Index
  include Pundit::Authorization
  attr_accessor :params, :records, :query
  def initialize(params, current_user = nil)
    @params = params
    @records = Api::AdminsPolicy::Scope.new(current_user, Admin).resolve
  end
  def execute
    name_start_with
    email_start_with
    order
    paginate
  end
  def name_start_with
    return if params.dig(:admins, :name).blank?
    @records = Admin.where('name like ?', "%#{params.dig(:admins, :name)}")
  end
  def email_start_with
    return if params.dig(:admins, :email).blank?
    @records = if records.is_a?(Class)
                 Admin.where(value.query)
               else
                 records.or(Admin.where('email like ?', "%#{params.dig(:admins, :email)}"))
               end
  end
  def order
    return if records.blank?
    @records = records.order('admins.created_at desc')
  end
  def paginate
    @records = Admin.none if records.blank? || records.is_a?(Class)
    @records = records.page(params.dig(:pagination_page) || 1).per(params.dig(:pagination_limit) || 20)
  end
  def moderate_content(user_id, content_id, content_type)
    user = User.find(user_id)
    raise Exceptions::NotAuthorizedError unless UserPolicy.new(user).admin?
    content = content_type.capitalize.constantize.find_by(id: content_id)
    raise Exceptions::NotFoundError, 'Content not found' if content.nil?
    # Return the content object to the controller for further actions
    content
  rescue ActiveRecord::RecordNotFound
    raise Exceptions::NotFoundError, 'User not found'
  end
end
# rubocop:enable Style/ClassAndModuleChildren
