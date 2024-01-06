# typed: ignore
module Api
  class BaseController < ApplicationController; end
  class QuestionsController < BaseController
    before_action :doorkeeper_authorize!
    before_action :check_admin_role, only: [:update]
    before_action :check_contributor_role, only: [:create]

    def create
      question_text = question_params[:question_text]
      answer_text = answer_params[:answer_text]
      tags_array = question_params[:tags]

      # Validate presence of question_text and answer_text using custom validators
      question_validator = QuestionValidator.new(question_text)
      tag_validator = TagValidator.new(tags_array)
      answer_validator = AnswerValidator.new(answer_text)

      if question_validator.valid? && tag_validator.valid? && answer_validator.valid?
        ActiveRecord::Base.transaction do
          # Ensure all tags exist or are created
          tags = tags_array.map { |tag_name| Tag.find_or_create_by!(name: tag_name) }

          question = Question.create!(question_text: question_text, user_id: current_resource_owner.id)
          question.tags = tags
          answer = Answer.create!(answer_text: answer_text, question_id: question.id)

          render json: {
            status: 201,
            question: question.as_json(only: [:id, :question_text, :created_at]),
            answer: answer.as_json(only: [:id, :answer_text, :question_id, :created_at]),
            tags: tags.map { |tag| { id: tag.id, question_id: question.id, tag: tag.name } }
          }, status: :created
        end
      else
        render json: {
          success: false,
          errors: question_validator.errors.full_messages +
                   tag_validator.errors.full_messages +
                   answer_validator.errors.full_messages
        }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'One or more tags are invalid.' }, status: :bad_request
    end

    def update
      return render json: { error: 'Question ID must be a number.' }, status: :bad_request unless params[:id].match?(/\A\d+\z/)

      ActiveRecord::Base.transaction do
        question = Question.find_by(id: params[:id])
        unless question
          return render json: { error: 'Question not found.' }, status: :not_found
        end

        answer = question.answers.first # Assuming each question has one answer for simplicity

        if params[:question_text]
          question.update!(question_text: params[:question_text])
        end

        if params[:answer_text] && answer
          answer.update!(answer_text: params[:answer_text])
        end

        render json: {
          status: 200,
          question: {
            id: question.id,
            question_text: question.question_text,
            updated_at: question.updated_at
          },
          answer: answer ? {
            id: answer.id,
            answer_text: answer.answer_text,
            question_id: question.id,
            updated_at: answer.updated_at
          } : nil
        }, status: :ok
      end
    rescue ActiveRecord::RecordInvalid => e
      render json: { errors: e.record.errors.full_messages }, status: :unprocessable_entity
    end

    private

    def question_params
      params.require(:question).permit(:question_text, tags: [])
    end

    def answer_params
      params.require(:answer).permit(:answer_text)
    end

    def check_admin_role
      user = current_resource_owner
      unless user && user.role == 'Administrator'
        render json: { error: 'You are not authorized to perform this action.' }, status: :unauthorized
      end
    end

    def check_contributor_role
      doorkeeper_authorize!
      user = current_resource_owner
      unless user && user.role == 'Contributor'
        render json: { error: 'Invalid contributor ID or insufficient permissions.' }, status: :unauthorized
      end
    end

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
