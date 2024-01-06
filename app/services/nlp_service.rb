# frozen_string_literal: true

class NlpService
  # Implement a method `parse_question` that takes "question_text" as input
  # and uses natural language processing to parse the text to understand the intent and context.
  # The method should return structured data that includes the identified intent
  # and relevant context or keywords that can be used to search for similar questions.

  def parse_question(question_text)
    # Assuming the integration with an NLP library or API is already set up and configured
    # Example: using a hypothetical NLP library called 'NlpParser'
    nlp_result = NlpParser.parse(question_text)

    # Extracting intent and context/keywords from the NLP result
    intent = nlp_result.intent
    keywords = nlp_result.keywords

    { intent: intent, keywords: keywords }
  end
end
