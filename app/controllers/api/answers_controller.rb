# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_contributor!, only: [:create]
    before_action :authenticate_user!, except: [:create, :search]
    before_action :authenticate_inquirer!, only: [:search]
    before_action :set_answer, only: [:update]
    before_action :authorize_answer, only: [:update]

    def create
      if validate_answer_submission(params[:content], params[:question_id])
        answer = Answer.new(answer_params.merge(user_id: current_user.id))

        if answer.save
          render json: { answer_id: answer.id }, status: :created
        else
          render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
        end
      end
    end

    def update
      authorize(@answer, :update?) # Added from new code to use Pundit for authorization

      raise ActiveRecord::RecordInvalid.new(@answer) if params[:content].blank?

      updated_answer = AnswerService::Update.call(@answer, params[:content]) # Updated to use AnswerService::Update

      if updated_answer
        render json: { message: I18n.t('answers.update_success') }, status: :ok
      else
        render json: { message: I18n.t('common.422') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      base_render_unprocessable_entity(e) # Updated to use base_render_unprocessable_entity from new code
    rescue Pundit::NotAuthorizedError => e
      base_render_unauthorized_error(e) # Updated to use base_render_unauthorized_error from new code
    end

    def search
      authorize :answer, :search?
      question_content = params.require(:question)
      if question_content.blank?
        render json: { error: 'Question cannot be empty.' }, status: :bad_request
        return
      end

      questions = Question.search_by_content(question_content)
      if params[:tags].present?
        tag_ids = Tag.where(name: params[:tags]).pluck(:id)
        questions = questions.joins(:question_tags).where(question_tags: { tag_id: tag_ids })
      end

      answers = Answer.where(question: questions).select(:id, :content, :question_id, :created_at)
      render json: { status: 200, answers: answers.as_json }, status: :ok
    end

    private

    def set_answer
      @answer = Answer.find_by(id: params[:id])
      render json: { error: 'Answer not found.' }, status: :not_found unless @answer
    end

    def authorize_answer
      render json: { error: 'You do not have permission to edit this answer.' }, status: :unauthorized unless @answer.user_id == current_user.id || Pundit.policy(current_user, @answer).update?
    end

    def answer_params
      params.require(:answer).permit(:content, :question_id)
    end

    def validate_answer_submission(content, question_id)
      # Assuming this method exists to validate the answer submission
      # The actual implementation should be provided here
    end

    # Additional methods from new code for error handling
    def base_render_unprocessable_entity(exception)
      render json: { errors: exception.record.errors.full_messages }, status: :unprocessable_entity
    end

    def base_render_unauthorized_error(exception)
      render json: { error: exception.message }, status: :unauthorized
    end
  end
end
