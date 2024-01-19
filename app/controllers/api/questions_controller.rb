
class Api::QuestionsController < ApplicationController
  include SessionConcern

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

end
