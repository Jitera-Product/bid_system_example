# typed: ignore
module Api
  class QuestionsController < ApplicationController
    include SessionConcern
    before_action :doorkeeper_authorize!, only: [:create]

    def create
      return unless CategoriesPolicy.new(current_resource_owner).contributor?

      question = Question.new(question_params.merge(user_id: current_resource_owner.id))

      if question.save
        render json: { id: question.id }, status: :created
      else
        render json: error_response(question, question.errors.full_messages.join(', ')), status: :unprocessable_entity
      end
    end

    def update
      contributor_id = params[:contributor_id]
      id = params[:id]
      content = params[:content]

      if validate_session(contributor_id)
        question = Question.find_by(id: id)
        policy = QuestionPolicy.new(question, current_user)

        if policy.update? && QuestionValidator.new(content).validate
          if QuestionService::Update.call(id: id, content: content, contributor_id: contributor_id)
            render json: { message: 'Question successfully updated.' }, status: :ok
          else
            render json: { error: 'Unable to update question.' }, status: :unprocessable_entity
          end
        else
          render json: { error: 'Not authorized or invalid content.' }, status: :forbidden
        end
      else
        render json: { error: 'Invalid session or contributor.' }, status: :unauthorized
      end
    end

    private

    def question_params
      params.require(:question).permit(:content, :category_id)
    end

    def error_response(resource, message)
      {
        errors: {
          status: '400',
          source: { pointer: "/data/attributes/#{resource.class.name.underscore}" },
          title: 'Bad Request',
          detail: message
        }
      }
    end
  end
end
