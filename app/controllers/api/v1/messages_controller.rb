# typed: ignore
module Api
  module V1
    class MessagesController < BaseController
      before_action :set_chat_channel, only: [:index, :show]
      before_action :validate_chat_channel_id, only: [:index, :show]

      def index
        authorize @chat_channel, :index?

        if @chat_channel.status != 'active'
          raise Exceptions::AuthenticationError, I18n.t('controller.chat_channel_disabled')
        end

        messages = @chat_channel.messages
        serialized_messages = MessageSerializer.new(messages).serializable_hash

        render json: { messages: serialized_messages, total: messages.count }, status: :ok
      rescue Exceptions::AuthenticationError => e
        render json: { error: e.message }, status: :forbidden
      end

      def show
        authorize @chat_channel, :index?

        unless @chat_channel.active?
          return render json: { error: I18n.t('controller.chat_channel_disabled') }, status: :forbidden
        end

        messages = @chat_channel.messages
        serialized_messages = MessageSerializer.new(messages).serializable_hash
        render json: { status: 200, messages: serialized_messages }, status: :ok
      end

      private

      def set_chat_channel
        @chat_channel = ChatChannel.find_by(id: params[:id] || params[:chat_channel_id])
      end

      def validate_chat_channel_id
        unless params[:id].present? && params[:id].match?(/\A\d+\z/)
          render json: { error: 'Chat channel ID must be provided and must be an integer.' }, status: :unprocessable_entity
        end

        unless @chat_channel
          render json: { error: I18n.t('controller.chat_channel_not_found') }, status: :not_found
        end
      end
    end
  end
end
