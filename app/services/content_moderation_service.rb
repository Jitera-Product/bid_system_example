
# rubocop:disable Style/ClassAndModuleChildren
class ContentModerationService
  include Pundit::Authorization
  include BaseService

  def initialize(content_id, content_type, action, admin_id, edited_content = nil)
    @content_id = content_id
    @content_type = content_type
    
    validate_input
    
    @action = action
    @admin_id = admin_id
    @edited_content = edited_content
  end

  def validate_input
    raise 'Content ID cannot be blank' if @content_id.blank?
    raise 'Content type cannot be blank' if @content_type.blank?
    raise 'Action cannot be blank' if @action.blank?
    raise 'Invalid content type' unless ['Question', 'Answer', 'Feedback'].include?(@content_type)
    raise 'Invalid action' unless ['approve', 'reject', 'edit'].include?(@action)
  end

  def moderate_content
    authenticate_admin
    content = find_content
    validate_input

    case @action
    when 'approve'
      content.update(status: 'approved')
      log_moderation('approved')
    when 'reject'
      # Assuming there is a status field to update instead of destroying the record
      content.update(status: 'rejected', rejection_reason: @edited_content)
      content.touch # This will update the `updated_at` timestamp
      log_moderation('rejected')
    when 'edit'
      raise 'Edited content cannot be blank' if @edited_content.blank?
      content.update(content: @edited_content)
      log_moderation('updated')
    else
      raise 'Invalid action'
    end

    { message: "Content has been #{@action}", moderation_status: content.status }
  end

  private
  
  def authenticate_admin
    # Assuming AdminService::Index class has a method to find an admin by id
    admin = AdminService::Index.find_admin(@admin_id)
    authorize admin, :moderate_content?
  end

  def find_content
    content = @content_type.constantize.find_by(id: @content_id)
    raise 'Content not found' unless content

    content
  end

  def log_moderation(status)
    logger.info "Content #{@content_id} has been #{status} by admin #{@admin_id}"
  end
end
# rubocop:enable Style/ClassAndModuleChildren
