
class AnswerService::Index
  # existing code...

  def update_relevance_score(answer, usefulness)
    if usefulness
      answer.relevance_score += 1
    else
      answer.relevance_score -= 1
    end

    answer.save
  end
end
