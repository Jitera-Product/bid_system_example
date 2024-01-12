module FeedbackService
  class Create
    def self.call(content, usefulness, answer_id)
      Feedback.create!(
        content: content,
        usefulness: usefulness,
        answer_id: answer_id
      )
    end
  end
end
