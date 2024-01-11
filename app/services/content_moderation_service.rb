# rubocop:disable Style/ClassAndModuleChildren
class ContentModerationService
  include Pundit::Authorization
  include BaseService

  def initialize(content_id, content_type, action, admin_id, edited_content = nil)
    @content_id = content_id
    @content_type = content_type
    @action = action
    @admin_id = admin_id
    @edited_content = edited_content
  end

  def moderate_content
    authenticate_admin
    content = find_content

    case @action
    when 'approve'
      content.update(status: 'approved')
      log_moderation('approved')
    when 'reject'
      content.destroy
      log_moderation('rejected')
    when 'edit'
      raise 'Edited content cannot be blank' if @edited_content.blank?
      content.update(content: @edited_content)
      log_moderation('updated')
    else
      raise 'Invalid action'
    end

    { moderation_status: @action }
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
