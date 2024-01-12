module Api
  class QuestionsController < BaseController
    include SessionConcern
    before_action :doorkeeper_authorize!, only: [:show, :update, :moderate]
    before_action :validate_admin_role, only: [:moderate]

    def show
      query = params[:query]
      begin
        answer_content = AnswerService.retrieve_answer(query)
        if answer_content
          render json: { answer: answer_content }, status: :ok
        else
          render json: { error: I18n.t('questions.answers.not_found') }, status: :not_found
        end
      rescue => e
        render json: { error: e.message }, status: :unprocessable_entity
      end
    end

    def create
      validate_contributor_session

      QuestionValidator.new.validate_title_and_content(params[:title], params[:content])
      TagValidator.new.validate_tags_existence(params[:tags])

      question = Question.create!(
        user_id: params[:contributor_id],
        title: params[:title],
        content: params[:content]
      )

      params[:tags].each do |tag_id|
        QuestionTag.create!(question_id: question.id, tag_id: tag_id)
      end

      render json: { id: question.id }, status: :created
    end

    def update
      validate_contributor_session
      question = Question.find_by(id: params[:id])
      return render json: { error: 'Question not found' }, status: :not_found unless question

      policy = QuestionPolicy.new(current_user, question)

      if policy.update?
        service = QuestionService::Update.new
        if service.update(question_id: params[:id], contributor_id: current_user.id, title: update_params[:title], content: update_params[:content], tags: update_params[:tags])
          render json: { message: 'Question updated successfully' }, status: :ok
        elsif service.errors.any?
          render json: { errors: service.errors }, status: :unprocessable_entity
        end
      else
        render json: { error: 'You are not authorized to update this question' }, status: :forbidden
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Question not found' }, status: :not_found
    end

    def moderate
      question = Question.find_by(id: params[:id])
      return render json: { error: 'Question not found' }, status: :not_found unless question

      if params[:tags]
        return render json: { error: 'One or more tags are invalid.' }, status: :unprocessable_entity unless TagValidator.new.validate_tags_existence(params[:tags])
      end

      question.update!(update_params.to_h)
      render json: { status: 200, question: question.as_json.merge(updated_at: question.updated_at) }, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Question not found' }, status: :not_found
    rescue ActionController::ParameterMissing
      render json: { error: 'Wrong format.' }, status: :unprocessable_entity
    rescue StandardError => e
      render json: { error: e.message }, status: :internal_server_error
    end

    private

    def update_params
      params.permit(:title, :content, tags: [])
    end

    def validate_admin_role
      render json: { error: 'Unauthorized' }, status: :unauthorized unless current_user.admin?
    end
  end
end
