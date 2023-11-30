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
  def moderate_content(content_id, action)
    begin
      content = Content.find_by(id: content_id)
      raise "Content not found" unless content
      case action
      when 'approve'
        content.update(status: 'approved')
      when 'reject'
        content.update(status: 'rejected')
      when 'edit'
        # perform edit action here
      else
        raise "Invalid action"
      end
      { message: "Content has been #{action}d", status: content.status }
    rescue => e
      Rails.logger.error "Error moderating content: #{e.message}"
      { error: e.message }
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
