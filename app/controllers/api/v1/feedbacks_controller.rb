
class Api::V1::FeedbacksController < Api::BaseController
  def create
    answer_id = feedback_params[:answer_id]
    content = feedback_params[:content]
    usefulness = feedback_params[:usefulness]

    unless Answer.exists?(answer_id)
      return render json: { error: 'Answer not found' }, status: :not_found
    end

    if content.blank?
      return render json: { error: 'Content cannot be blank' }, status: :unprocessable_entity
    end

    sanitized_content = ActiveRecord::Base.sanitize_sql(content)
    feedback = FeedbackService::Create.call(sanitized_content, usefulness, answer_id)
    render json: { feedback_id: feedback.id }, status: :created
  end

  private
  def feedback_params
    params.require(:feedback).permit(:content, :usefulness, :answer_id)
  end
end
