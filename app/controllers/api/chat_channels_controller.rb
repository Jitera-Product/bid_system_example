# typed: true
# frozen_string_literal: true

module Api
  class ChatChannelsController < BaseController
    before_action :doorkeeper_authorize!, only: [:check_availability, :retrieve_chat_messages, :disable]

    def check_availability
      chat_channel = ChatChannel.find_by(id: params[:id])
      unless chat_channel
        return base_render_record_not_found('Chat channel not found.')
      end

      unless chat_channel.bid_item.status == 'active'
        raise Exceptions::ChatChannelNotActiveError, I18n.t('chat_channel_not_active')
      end

      if chat_channel.messages.count > 30
        raise Exceptions::ChatChannelNotActiveError, I18n.t('chat_channel_not_active')
      end

      render json: { status: 200, availability: true }
    rescue Exceptions::ChatChannelNotActiveError => e
      base_render_chat_channel_not_active(e)
    end

    def retrieve_chat_messages
      chat_channel = ChatChannel.find_by!(id: params[:chat_channel_id], is_active: true)
      messages = chat_channel.messages
                              .page(params[:page])
                              .per(params[:per_page])

      if messages.present?
        render json: {
          status: I18n.t('common.200'),
          messages: messages,
          total_count: messages.total_count
        }, status: :ok
      else
        render json: {
          status: I18n.t('common.404'),
          error: 'No messages found.'
        }, status: :not_found
      end
    end

    def disable
      chat_channel = ChatChannel.find(params[:id])
      authorize chat_channel

      bid_item = chat_channel.bid_item
      if bid_item.status != 'done'
        render json: { message: I18n.t('chat_channel.errors.not_done') }, status: :unprocessable_entity
        return
      end

      if chat_channel.is_active
        chat_channel.update!(is_active: false)
        render json: chat_channel, status: :ok
      else
        render json: { message: I18n.t('chat_channel.errors.already_disabled') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { message: I18n.t('chat_channel.errors.not_found') }, status: :not_found
    end

    private

    def base_render_chat_channel_not_active(exception)
      render json: { error: exception.message }, status: :forbidden
    end

    # Add any other private methods from the existing code below this line
  end
end
