
# typed: ignore
module Api
  class BaseController < ApplicationController; end
  class QuestionsController < BaseController
    before_action :doorkeeper_authorize!
    before_action :check_contributor_role, only: [:create]

    def create
      ActiveRecord::Base.transaction do
        question_validator = QuestionValidator.new(question_params[:question_text])
        tag_validator = TagValidator.new(question_params[:tags])
        answer_validator = AnswerValidator.new(answer_params[:answer_text])

        if question_validator.valid? && tag_validator.valid? && answer_validator.valid?
          # Ensure all tags exist or are created
          tags = question_params[:tags].map { |tag_name| Tag.find_or_create_by!(name: tag_name) }

          question = Question.create!(question_text: question_params[:question_text], user_id: current_resource_owner.id)
          question.tags = tags
          answer = Answer.create!(answer_text: answer_params[:answer_text], question_id: question.id)

          render json: { status: 201, question: question.as_json, answer: answer.as_json }, status: :created
        else
          render json: { success: false, errors: question_validator.errors.full_messages + tag_validator.errors.full_messages + answer_validator.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'One or more tags are invalid.' }, status: :bad_request
    end

    private

    def question_params # Update the permitted parameters to include `tags` as an array of strings.
      params.require(:question).permit(:question_text, tags: [])
    end

    def answer_params
      params.require(:answer).permit(:answer_text)
    end

    def check_contributor_role # Update the method to use `doorkeeper_authorize!` and check for the "Contributor" role.
      doorkeeper_authorize!
      user = User.find_by(id: params[:contributor_id])
      unless user && user.role == 'Contributor'
        render json: { error: 'Invalid contributor ID or insufficient permissions.' }, status: :unauthorized
      end
    end
  end
end
