class QuestionPolicy
  def update?(question, user)
    user.id == question.contributor_id
  end
end


