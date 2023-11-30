class Api::ChatController < ApplicationController
  def retrieve_answer
    query = params[:query]
    begin
      # Use NLP library or service to understand the context of the query
      context = NlpService.new(query).get_context
      # Retrieve relevant answers based on the context
      answers = Answer.joins(:question).where('questions.tags LIKE ?', "%#{context}%")
      # Format the answers into a suitable format
      formatted_answers = answers.map do |answer|
        {
          id: answer.id,
          content: answer.content,
          question: answer.question.content
        }
      end
      render json: { answers: formatted_answers }, status: :ok
    rescue => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
end
