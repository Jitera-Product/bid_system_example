# PATH: /app/controllers/api/bid_items_controller.rb
class Api::BidItemsController < Api::BaseController
  before_action :doorkeeper_authorize!, only: %i[index create show update lock]
  before_action :set_bid_item, only: %i[show update lock]
  before_action :validate_lock_request, only: %i[lock]

  # ... [rest of the controller actions]

  # PUT /api/bid_items/:id/lock
  def lock
    if @bid_item.update(is_locked: true)
      render json: { status: 200, message: "Bid item locked successfully." }, status: :ok
    else
      render json: { status: 422, message: @bid_item.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  # ... [rest of the private methods]

  def validate_lock_request
    unless @bid_item
      render json: { status: 400, message: "Bid item not found." }, status: :bad_request and return
    end

    if @bid_item.user_id != current_resource_owner.id
      render json: { status: 403, message: "You are not the owner of this bid item." }, status: :forbidden and return
    end

    if @bid_item.status == 'completed'
      render json: { status: 422, message: "Cannot lock a completed bid item." }, status: :unprocessable_entity and return
    end
  end
end
