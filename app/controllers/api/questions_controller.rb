# typed: ignore
module Api
  class QuestionsController < BaseController
    include SessionConcern
    before_action :validate_contributor_session, only: [:create]

    def create
      # Validate input 'content' using QuestionValidator
      validator = QuestionValidator.new(question_params)
      unless validator.valid?
        return render json: { errors: validator.errors.full_messages }, status: :unprocessable_entity
      end

      # Validate 'contributor_id' to ensure it is a Contributor
      contributor = User.find_by(id: question_params[:contributor_id])
      unless contributor&.role == 'Contributor'
        return render json: { message: 'Invalid contributor ID or contributor does not have the correct role' }, status: :forbidden
      end

      # Validate each 'tag_id' in the 'tags' array
      unless Tag.where(id: question_params[:tags]).count == question_params[:tags].size
        return render json: { message: 'One or more tags are invalid' }, status: :unprocessable_entity
      end

      # Create the question and associate tags using QuestionService::Index
      question = QuestionService::Index.create_question_with_tags(question_params[:content], contributor, question_params[:tags])

      # Return the 'id' of the newly created question as 'question_id' in the response
      render json: { question_id: question.id }, status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { message: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    private

    def question_params
      params.require(:question).permit(:content, :contributor_id, tags: [])
    end

    def validate_contributor_session
      unless current_user && current_user.role == 'Contributor'
        render json: { message: 'You must be logged in as a Contributor to perform this action' }, status: :unauthorized
      end
    end
  end
end
