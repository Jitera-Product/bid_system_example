
class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update moderate_content]

  def index
    # inside service params are checked and whiteisted
    @admins = AdminService::Index.new(params.permit!, current_resource_owner).execute
    @total_pages = @admins.total_pages
  end

  def show
    @admin = Admin.find_by!('admins.id = ?', params[:id])

    authorize @admin, policy_class: Api::AdminsPolicy
  end

  def create
    @admin = Admin.new(create_params)

    authorize @admin, policy_class: Api::AdminsPolicy

    return if @admin.save

    @error_object = @admin.errors.messages

    render status: :unprocessable_entity
  end

  def update
    @admin = Admin.find_by('admins.id = ?', params[:id])
    raise ActiveRecord::RecordNotFound if @admin.blank?

    authorize @admin, policy_class: Api::AdminsPolicy

    return if @admin.update(update_params)

    @error_object = @admin.errors.messages

    render status: :unprocessable_entity
  end

  def moderate_content
    # Step 1: Authenticate the admin user
    doorkeeper_authorize!
    admin = current_resource_owner
    authorize admin, policy_class: Api::AdminsPolicy

    # Step 2: Validate the input
    content_id = params.require(:content_id)
    content_type = params.require(:content_type)
    action = params.require(:action)
    admin_id = params.require(:admin_id)

    # Ensure the admin_id matches the current admin user
    raise Pundit::NotAuthorizedError unless admin.id == admin_id

    # Step 3: Find the content based on content_type and content_id
    content = content_type == 'question' ? Question.find(content_id) : Answer.find(content_id)

    # Step 4: Update the status of the content based on the action
    if action == 'approve'
      content.update!(status: 'approved')
    elsif action == 'reject'
      content.update!(status: 'rejected')
    else
      raise ArgumentError, 'Invalid action'
    end

    # Step 5: Log the moderation action (This can be done using a logging mechanism or a dedicated model for audit logs)

    # Step 6: Return a confirmation message
    render json: { message: "Content has been #{action}d." }, status: :ok
  end

  private

  def create_params
    params.require(:admins).permit(:name, :email)
  end

  def update_params
    params.require(:admins).permit(:name, :email)
  end
end
