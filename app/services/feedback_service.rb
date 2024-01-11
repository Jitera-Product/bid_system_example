# rubocop:disable Style/ClassAndModuleChildren
class FeedbackService
  include ActiveModel::Model

  def create_feedback(comment, usefulness, inquirer_id, answer_id)
    raise ArgumentError, 'usefulness must be a boolean' unless [true, false].include?(usefulness)

    answer = Answer.find_by(id: answer_id)
    raise ActiveRecord::RecordNotFound, 'Answer not found' if answer.nil?

    feedback = Feedback.new(
      comment: comment,
      usefulness: usefulness,
      answer_id: answer_id
    )

    if feedback.save
      update_answer_ranking(answer) if respond_to?(:update_answer_ranking)
      feedback
    else
      raise ActiveRecord::RecordInvalid, 'Feedback could not be saved'
    end
  end

  private

  # Optional method to update answer ranking
  # def update_answer_ranking(answer); end
end
# rubocop:enable Style/ClassAndModuleChildren
