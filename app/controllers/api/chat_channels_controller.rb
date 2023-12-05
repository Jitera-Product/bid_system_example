# FILE PATH: /app/controllers/api/chat_channels_controller.rb

module Api
  class ChatChannelsController < ApplicationController
    before_action :doorkeeper_authorize!, only: [:create]

    def create
      bid_item = BidItem.find_by(id: params[:bid_item_id])
      unless bid_item
        return render json: { error: "Bid item not found." }, status: :bad_request
      end

      if bid_item.chat_enabled == false
        render json: { error: "Can not create channel for this item." }, status: :bad_request
      else
        # Channel creation logic goes here
      end
    rescue Exceptions::AuthenticationError
      render json: { error: "User must be authenticated." }, status: :bad_request
    end

    private

    def doorkeeper_authorize!
      # User authentication logic goes here
      raise Exceptions::AuthenticationError unless current_resource_owner
    end
  end
end
