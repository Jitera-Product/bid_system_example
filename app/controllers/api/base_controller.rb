
# typed: ignore
module Api
  class BaseController < ActionController::API
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
    
    def send_chat_message(chat_session_id, message, sender_id)
      chat_session = ChatSession.find_by(id: chat_session_id)
      unless chat_session&.is_active
        render json: { message: I18n.t('common.errors.chat_session_not_active') }, status: :unprocessable_entity
        return
      end

      if message.length > 512
        render json: { message: I18n.t('common.errors.message_too_long') }, status: :unprocessable_entity
        return
      end

      if chat_session.chat_messages.count >= 30
        render json: { message: I18n.t('common.errors.message_limit_exceeded') }, status: :unprocessable_entity
        return
      end

      chat_message = chat_session.chat_messages.build(message: message, user_id: sender_id)

      if chat_message.save
        render 'api/chat_messages/create', locals: { chat_message: chat_message }, status: :created
      else
        render json: { message: chat_message.errors.full_messages.to_sentence }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { message: I18n.t('common.errors.chat_session_not_found') }, status: :not_found
    rescue ActiveRecord::RecordInvalid
      render json: { message: I18n.t('common.errors.sender_not_found') }, status: :unprocessable_entity
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
