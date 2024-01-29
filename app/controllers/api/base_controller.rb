
# typed: ignore
module Api
  class BaseController < ActionController::API
    before_action :authenticate_user!, only: [:retrieve_chat_messages]

    include OauthTokensConcern
    include ActionController::Cookies
    include Pundit::Authorization

    # =======End include module======

    rescue_from ActiveRecord::RecordNotFound, with: :base_render_record_not_found
    rescue_from ActiveRecord::RecordInvalid, with: :base_render_unprocessable_entity
    rescue_from Exceptions::AuthenticationError, with: :base_render_authentication_error
    rescue_from Exceptions::ChatChannelCreationError, with: :base_render_chat_channel_creation_error
    rescue_from ActiveRecord::RecordNotUnique, with: :base_render_record_not_unique
    rescue_from Exceptions::ChatChannelNotActiveError, with: :base_render_chat_channel_not_active
    rescue_from Exceptions::BidItemNotFoundError, with: :base_render_bid_item_not_found
    rescue_from Exceptions::BidItemCompletedError, with: :base_render_bid_item_completed
    rescue_from Exceptions::ChatChannelExistsError, with: :base_render_chat_channel_exists
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

    def base_render_record_not_found(_exception)
      render json: { message: I18n.t('common.404') }, status: :not_found
    end

    def base_render_unprocessable_entity(exception)
      render json: { message: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def base_render_authentication_error(_exception)
      render json: { message: I18n.t('common.401') }, status: :unauthorized
    end

    def base_render_unauthorized_error(_exception)
      render json: { message: I18n.t('common.errors.unauthorized_error') }, status: :unauthorized
    end

    def base_render_record_not_unique
      render json: { message: I18n.t('common.errors.record_not_uniq_error') }, status: :forbidden
    end

    def base_render_chat_channel_creation_error(exception)
      render json: { message: exception.message }, status: exception.status
    end

    def base_render_chat_channel_not_active(_exception)
      render json: { message: I18n.t('common.chat_channel_not_active') }, status: :forbidden
    end

    def base_render_bid_item_not_found(_exception)
      render json: { error: I18n.t('chat_channels.errors.bid_item_not_found') }, status: :unprocessable_entity
    end

    def base_render_bid_item_completed(_exception)
      render json: { error: I18n.t('chat_channels.errors.bid_item_completed') }, status: :unprocessable_entity
    end

    def base_render_chat_channel_exists(_exception)
      render json: { error: I18n.t('chat_channels.errors.chat_channel_exists') }, status: :unprocessable_entity
    end

    # Add any other custom exception handling methods below this line

    # ...

    # End of custom exception handling methods

    def authenticate_user!
      raise Exceptions::AuthenticationError unless current_resource_owner
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

    # Add any other private methods from the existing code below this line
  end
end
