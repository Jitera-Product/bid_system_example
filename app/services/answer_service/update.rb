# typed: true
module AnswerService
  class Update < BaseService
    def self.call(answer, content)
      begin
        answer.content = content
        answer.save!
        answer
      rescue ActiveRecord::RecordInvalid => e
        raise e
      end
    end
  end
end

