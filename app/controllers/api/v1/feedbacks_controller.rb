
class Api::V1::FeedbacksController < BaseController
  before_action :authenticate_user!

  def create
    answer = Answer.find(params[:answer_id])
    feedback = Feedback.new(
      answer_id: answer.id,
      inquirer_id: current_user.id,
      usefulness: params[:usefulness],
      comment: params[:comment]
    )

    if feedback.save
      FeedbackService.new.update_relevance_score(answer, params[:usefulness])
      render json: { message: 'Feedback successfully recorded' }, status: :created
    else
      render json: { errors: feedback.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
