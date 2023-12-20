class Api::AdminsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update]
  before_action :validate_id_format, only: [:show] # Keep this line to validate ID format for the show action
  before_action :set_admin, only: %i[show update]
  rescue_from Exceptions::AuthenticationError, with: :handle_authentication_error
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found # Keep this line from the new code

  # ... [rest of the index and show actions from the existing code]

  def create
    @admin = Admin.new(create_params)

    authorize @admin, policy_class: Api::AdminsPolicy

    if @admin.save
      # Handle successful creation, e.g., render or redirect as needed
    else
      @error_object = @admin.errors.messages
      render status: :unprocessable_entity
    end
  end

  def create_params
    # Combine the create_params from both versions, ensuring all required parameters are permitted
    params.require(:admin).permit(:name, :email)
  end

  def update
    authorize @admin, policy_class: Api::AdminsPolicy

    # Add the ID format check from the new code
    if update_params[:id].to_i.to_s != update_params[:id]
      render json: { error: "Wrong format." }, status: :bad_request
      return
    end

    # Add the email format check from the new code
    if update_params[:email].present? && !update_params[:email].match?(/\A[^@\s]+@[^@\s]+\z/)
      render json: { error: "Invalid email format." }, status: :unprocessable_entity
      return
    end

    # Add the name presence check from the new code
    if update_params[:name].blank?
      render json: { error: "The name is required." }, status: :unprocessable_entity
      return
    end

    if @admin.update(update_params)
      # Use the response format from the new code
      render json: { status: 200, admin: @admin.as_json(only: [:id, :email, :name, :created_at, :updated_at]) }, status: :ok
    else
      # Use the error handling from the existing code
      @error_object = @admin.errors.messages
      render json: { errors: @error_object }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: e.record.errors.messages }, status: :unprocessable_entity
  end

  def update_params
    # Keep the update_params from the new code as it includes the :id parameter
    params.require(:admin).permit(:id, :name, :email)
  end

  private

  def set_admin
    # Use the find_by method from the new code to avoid raising an exception
    @admin = Admin.find_by(id: params[:id])
    unless @admin
      render json: { error: I18n.t('controller.admin.not_found') }, status: :not_found
    end
  end

  def validate_id_format
    # Keep this method from the existing code to validate ID format for the show action
    unless params[:id] =~ /\A\d+\z/
      render json: { error: 'Wrong format.' }, status: :bad_request
    end
  end

  def record_not_found
    # Keep this method from the new code
    render json: { error: I18n.t('controller.admin.not_found') }, status: :not_found
  end

  def handle_authentication_error
    # Keep this method from the existing code
    render json: { error: I18n.t('controller.authentication_error') }, status: :unauthorized
  end
end
