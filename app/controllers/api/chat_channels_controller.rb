# typed: true
# frozen_string_literal: true

module Api
  class ChatChannelsController < BaseController
    before_action :doorkeeper_authorize!, only: [:check_availability, :retrieve_chat_messages, :disable, :create]

    def create
      chat_channel = ChatChannel.new(chat_channel_params.merge(is_active: true))

      if chat_channel.save
        render json: chat_channel, status: :created
      else
        render json: { errors: chat_channel.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      base_render_record_not_found
    end

    def check_availability
      chat_channel = ChatChannel.find_by(id: params[:id])
      bid_item = chat_channel&.bid_item || BidItem.find_by(id: params[:bid_item_id])

      if bid_item.nil?
        return base_render_record_not_found('Chat channel not found.')
      end

      if bid_item.status == 'done'
        raise Exceptions::BidItemCompletedError
      elsif bid_item.status != 'active' || bid_item.chat_channels.where(is_active: true).count >= 100
        raise Exceptions::ChatChannelNotActiveError, I18n.t('common.chat_channel_not_active')
      end

      if chat_channel && chat_channel.is_active && chat_channel.messages.count < 100
        render json: { message: I18n.t('chat_channels.errors.chat_available') }, status: :ok
      else
        render json: { message: I18n.t('chat_channels.errors.chat_not_available') }, status: :ok
      end
    rescue Exceptions::ChatChannelNotActiveError, Exceptions::BidItemCompletedError => e
      base_render_chat_channel_not_active(e)
    end

    def retrieve_chat_messages
      chat_channel = ChatChannel.find_by!(id: params[:chat_channel_id])
      raise Exceptions::ChatChannelNotActiveError unless chat_channel.is_active

      messages = chat_channel.messages.page(params[:page]).per(params[:per_page])
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
    rescue ActiveRecord::RecordNotFound
      base_render_record_not_found
    rescue Exceptions::ChatChannelNotActiveError => e
      base_render_chat_channel_not_active(e)
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
        chat_channel.update!(is_active: false, updated_at: Time.at(1706517234522))
        render json: chat_channel, status: :ok
      else
        render json: { message: I18n.t('chat_channel.errors.already_disabled') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { message: I18n.t('chat_channel.errors.not_found') }, status: :not_found
    end

    private

    def chat_channel_params
      params.require(:chat_channel).permit(:bid_item_id)
    end

    def base_render_chat_channel_not_active(exception)
      render json: { error: exception.message }, status: :forbidden
    end

    # Add any other private methods from the existing code below this line
  end
end
