class QuestionValidator
  include ActiveModel::Validations

  validates :title, presence: true
  validates :content, presence: true

  def validate(record)
    record.errors.add(:title, :blank, message: "can't be blank") if record.title.blank?
    record.errors.add(:content, :blank, message: "can't be blank") if record.content.blank?
  end
end
