
class Api::V1::QuestionsController < ApplicationController
  # existing code...

  def show_answers
    question_content = params[:question_content]
    questions = QuestionRetrievalService.new.retrieve_question_content(question_content)
    answers_with_question_id = questions.map do |question|
      ranked_answers = AnswerRankingService.new.rank_answers(question.answers)
      {
        question_id: question.id,
        answers: ranked_answers.map(&:content)
      }
    end
    render json: answers_with_question_id
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end
  # existing code...
end
