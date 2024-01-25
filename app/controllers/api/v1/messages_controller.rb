# typed: ignore
module Api
  module V1
    class MessagesController < BaseController
      def index
        chat_channel = ChatChannel.find_by(id: params[:chat_channel_id])
        raise Exceptions::AuthenticationError, I18n.t('controller.chat_channel_not_found') unless chat_channel

        authorize chat_channel, :index?

        if chat_channel.status != 'active'
          raise Exceptions::AuthenticationError, I18n.t('controller.chat_channel_disabled')
        end

        messages = chat_channel.messages
        serialized_messages = MessageSerializer.new(messages).serializable_hash

        render json: { messages: serialized_messages, total: messages.count }, status: :ok
      rescue Exceptions::AuthenticationError => e
        render json: { error: e.message }, status: :forbidden
      end
    end
  end
end
