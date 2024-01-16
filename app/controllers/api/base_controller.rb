# typed: ignore
module Api
  class BaseController < ActionController::API
    before_action :doorkeeper_authorize!, only: [:moderate_content]
    include OauthTokensConcern
    include ActionController::Cookies
    include Pundit::Authorization

    # =======End include module======

    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :base_render_unprocessable_entity
    rescue_from Exceptions::AuthenticationError, with: :base_render_authentication_error
    rescue_from ActiveRecord::RecordNotUnique, with: :base_render_record_not_unique
    rescue_from Pundit::NotAuthorizedError, with: :base_render_unauthorized_error

    def error_response(resource, error)
      {
        success: false,
        full_messages: resource&.errors&.full_messages,
        errors: resource&.errors,
        error_message: error.message,
        backtrace: error.backtrace
      }
    end

    private
    
    def moderate_content
      # Authenticate the user using the `admin?` method from `AdminsPolicy`.
      admin = current_resource_owner
      raise Pundit::NotAuthorizedError unless AdminsPolicy.new(admin, nil).admin?

      # Validate the input to ensure that `content_id` corresponds to an existing question or answer based on `content_type`.
      content_id = params.require(:content_id)
      content_type = params.require(:content_type)
      action = params.require(:action)

      content = content_type == 'question' ? Question.find(content_id) : Answer.find(content_id)

      # Depending on the `action` parameter, update the status of the content in the database to reflect its approval or rejection.
      content.update_moderation_status(action)

      # Log the moderation action taken by the admin using the `Rails.logger` or a custom logger for auditing purposes.
      Rails.logger.info("Admin ##{admin.id} has #{action}ed content ##{content_id} of type #{content_type}")

      # Return a confirmation message indicating the content has been moderated.
      render json: { message: "Content has been #{action}d." }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { message: 'Content not found' }, status: :not_found
    rescue Pundit::NotAuthorizedError
      render json: { message: 'Not authorized to perform this action' }, status: :unauthorized
    rescue ArgumentError => e
      render json: { message: e.message }, status: :unprocessable_entity
    end

    def provide_feedback
      answer_id = params[:answer_id]
      user_id = params[:user_id]
      comment = params[:comment]
      usefulness = params[:usefulness]

      message = FeedbackService.create_feedback(answer_id, user_id, comment, usefulness)

      render json: { message: message }, status: :ok
    end

    def base_render_record_not_found(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unprocessable_entity(exception)
      render json: { message: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def base_render_authentication_error(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unauthorized_error(_exception)
      render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :unauthorized
    end

    def base_render_record_not_unique
      render json: { message: I18n.t('common.errors.record_not_uniq_error') }, status: :forbidden
    end

    def custom_token_initialize_values(resource, client)
      token = CustomAccessToken.create(
        application_id: client.id,
        resource_owner: resource,
        scopes: resource.class.name.pluralize.downcase,
        expires_in: Doorkeeper.configuration.access_token_expires_in.seconds
      )
      @access_token = token.token
      @token_type = 'Bearer'
      @expires_in = token.expires_in
      @refresh_token = token.refresh_token
      @resource_owner = resource.class.name
      @resource_id = resource.id
      @created_at = resource.created_at
      @refresh_token_expires_in = token.refresh_expires_in
      @scope = token.scopes
    end

    def current_resource_owner
      return super if defined?(super)
    end
  end
end
