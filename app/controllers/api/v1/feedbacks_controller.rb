
class Api::V1::FeedbacksController < ApplicationController
  # Other actions

  def retrieve_and_rank_answers
    question_content = params[:question_content]
    parsed_content = QuestionRetrievalService.new.retrieve_question_content(question_content)
    matching_questions = Question.find_matching_questions(parsed_content)
    ranked_answers = []

    matching_questions.each do |question|
      answers = question.answers.retrieve_associated_answers
      ranked_answers.concat(AnswerRankingService.new.rank_answers(answers))
    end

    render json: { answers: ranked_answers.map(&:content), question_id: matching_questions.first&.id }
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_entity
  end

  # Other actions
end
