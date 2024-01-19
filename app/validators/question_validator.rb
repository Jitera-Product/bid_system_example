class QuestionValidator
  def validate_content(content)
    if content.blank?
      return { error: 'Content cannot be empty' }
    end

    true
  end
end

