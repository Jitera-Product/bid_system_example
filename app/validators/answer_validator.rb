class AnswerValidator < ActiveModel::Validator
  def validate(record)
    validate_content(record)
    validate_question_id(record)
  end

  private

  def validate_content(record)
    record.errors.add(:content, "can't be empty") if record.content.blank?
  end

  def validate_question_id(record)
    record.errors.add(:question_id, "must correspond to an existing question") unless Question.exists?(record.question_id)
  end
end
