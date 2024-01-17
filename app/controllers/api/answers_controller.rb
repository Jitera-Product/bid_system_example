# typed: ignore
module Api
  class AnswersController < BaseController
    before_action :authenticate_contributor!, only: [:create]
    before_action :authenticate_user!, except: [:create, :search]
    before_action :authenticate_inquirer!, only: [:search]
    before_action :set_answer, only: [:update]
    before_action :authorize_answer, only: [:update]
    include Api::AnswersPolicy

    def create
      # Validate if the question exists
      unless Question.exists?(params[:question_id])
        return render json: { errors: "Question not found." }, status: :bad_request
      end

      # Validate if the content is not blank
      if params[:content].blank?
        return render json: { errors: "Answer content cannot be empty." }, status: :bad_request
      end

      answer = Answer.new(answer_params.merge(user_id: current_user.id))

      if answer.save
        render json: { status: 201, answer: answer.as_json }, status: :created
      else
        render json: { errors: answer.errors.full_messages }, status: :unprocessable_entity
      end
    end

    def update
      authorize(@answer, :update?)

      raise ActiveRecord::RecordInvalid.new(@answer) if params[:content].blank?

      updated_answer = AnswerService::Update.call(@answer, params[:content])

      if updated_answer
        render json: { message: I18n.t('answers.update_success') }, status: :ok
      else
        render json: { message: I18n.t('common.422') }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      base_render_unprocessable_entity(e)
    rescue Pundit::NotAuthorizedError => e
      base_render_unauthorized_error(e)
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

    # Assuming this method exists to validate the answer submission
    # The actual implementation should be provided here
    def validate_answer_submission(content, question_id)
      # Validate if the question exists
      unless Question.exists?(question_id)
        return false, { errors: "Question not found." }
      end

      # Validate if the content is not blank
      if content.blank?
        return false, { errors: "Answer content cannot be empty." }
      end

      true, {}
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
