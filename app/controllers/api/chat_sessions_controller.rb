module Api
  class ChatSessionsController < BaseController
    before_action :authenticate_user!, except: [:create, :send_message]
    before_action :doorkeeper_authorize!, only: [:create, :send_message]
    before_action :set_chat_session, only: [:retrieve_chat_history, :send_message]
    before_action :authorize_retrieve_chat_history, only: [:retrieve_chat_history]

    def create
      bid_item_id = params[:bid_item_id]
      user_id = current_resource_owner.id

      unless bid_item_id.present? && bid_item_id.to_s.match?(/\A\d+\z/)
        return render json: { message: I18n.t('common.errors.invalid_bid_item_id') }, status: :bad_request
      end

      begin
        chat_session = ChatSessionService.create_chat_session(bid_item_id: bid_item_id.to_i, user_id: user_id)
        render 'api/chat_sessions/create', locals: { chat_session: chat_session }, status: :created
      rescue ActiveRecord::RecordNotFound => e
        render json: { message: e.message }, status: :not_found
      rescue Exceptions::AuthenticationError, Pundit::NotAuthorizedError => e
        render json: { message: e.message }, status: :unauthorized
      rescue StandardError => e
        render json: error_response(nil, e), status: :internal_server_error
      end
    end

    def retrieve_chat_history
      if @chat_session.is_active
        messages = @chat_session.messages.includes(:user).page(params[:page]).per(params[:per_page])
        render 'api/chat_sessions/retrieve_chat_history', locals: { messages: messages }, status: :ok
      else
        render json: { message: I18n.t('chat_sessions.chat_disabled') }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound => e
      base_render_record_not_found(e)
    end

    def send_message
      return render json: { message: I18n.t('common.404') }, status: :not_found unless @chat_session
      return render json: { message: I18n.t('common.errors.chat_session_not_active') }, status: :unprocessable_entity unless @chat_session.is_active

      user = User.find(params[:user_id])
      return render json: { message: I18n.t('common.404') }, status: :not_found unless user

      if params[:content].blank? || params[:content].length > 512
        return render json: { message: I18n.t('common.errors.content_length') }, status: :unprocessable_entity
      end

      message_count = Message.where(chat_session_id: @chat_session.id).count
      if message_count > 30
        return render json: { message: I18n.t('common.errors.message_limit_reached') }, status: :unprocessable_entity
      end

      message = @chat_session.messages.create!(user_id: user.id, content: params[:content])
      @chat_session.touch

      render json: { status: 201, message: message.as_json(only: [:id, :chat_session_id, :user_id, :content, :created_at]) }, status: :created
    rescue ActiveRecord::RecordNotFound => e
      render json: error_response(nil, e), status: :not_found
    rescue ActiveRecord::RecordInvalid => e
      render json: error_response(nil, e), status: :unprocessable_entity
    end

    private

    def set_chat_session
      @chat_session = ChatSession.find(params[:id] || params[:chat_session_id])
    end

    def authorize_retrieve_chat_history
      authorize @chat_session, :retrieve_chat_history?
    end

    def error_response(resource, e)
      {
        error: {
          type: e.class.to_s,
          message: e.message,
          details: resource&.errors&.full_messages
        }
      }
    end
  end
end
