# typed: true
module Api
  class RequestsController < BaseController
    before_action :doorkeeper_authorize!

    def create
      request = Request.new(request_params)
      request.user_id = request_params[:visitor_id]
      request.status = 'pending'

      if request.save
        render json: { status: I18n.t('common.201'), request: request }, status: :created
      else
        base_render_unprocessable_entity(request)
      end
    end

    private

    def request_params
      params.permit(:description, :visitor_id, :hair_stylist_id)
    end
  end
end

