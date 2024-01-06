
class Api::V1::AnswersController < ApplicationController
  def retrieve_answer
    question_text = params[:question_text]
    parsed_question = NlpService.parse(question_text)
    similar_questions = QuestionRetrievalService.find_similar_questions(parsed_question)

    answers = similar_questions.map do |question|
      {
        question_id: question.id,
        answer_text: question.answers.map(&:answer_text),
        metadata: {
          created_at: question.created_at,
          updated_at: question.updated_at
        }
      }
    end

    # Log the inquiry and response
    logger.info "Inquiry: #{question_text} - Response: #{answers}"

    render json: answers
  end
end
