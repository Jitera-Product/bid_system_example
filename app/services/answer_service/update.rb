# typed: true
module AnswerService
  class Update < BaseService
    def call(answer, content)
      raise ArgumentError, 'Content cannot be empty' if content.blank?

      if answer.update(content: content)
        { message: 'Answer successfully updated.' }
      else
        raise StandardError, 'Error updating the answer.'
      end
    end
  end
end

