# typed: true
module QuestionService
  class Create < BaseService
    def initialize(content, tag_ids, user)
      @content = content
      @tag_ids = tag_ids
      @user = user
    end

    def call
      raise ArgumentError, 'Content cannot be blank' if @content.blank?
      raise ArgumentError, 'Tags cannot be blank' if @tag_ids.blank?

      Question.transaction do
        question = Question.create!(content: @content, user: @user)
        @tag_ids.each do |tag_id|
          raise ArgumentError, 'Tag does not exist' unless Tag.exists?(id: tag_id)
          QuestionTag.create!(question: question, tag_id: tag_id)
        end
        question
      end
    rescue ActiveRecord::RecordInvalid => e
      raise e.message
    end
  end
end
