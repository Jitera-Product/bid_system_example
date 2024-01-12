# frozen_string_literal: true

class FeedbackService
  def update_answer_relevance(answer, usefulness)
    relevance_change = usefulness ? 1 : -1
    answer.relevance_score ||= 0
    answer.relevance_score += relevance_change

    if answer.save
      true
    else
      raise StandardError.new(answer.errors.full_messages.join(', '))
    end
  end
end
