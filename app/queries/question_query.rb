class QuestionQuery
  def self.search_by_terms(query)
    terms = query.split(/\s+/).map { |term| "%#{term}%" }
    conditions = terms.map { |term| "title ILIKE ? OR content ILIKE ?" }.join(' OR ')
    Question.where(conditions, *terms.flat_map { |term| [term, term] })
  end
end

# Note: This is a simple implementation. Depending on the complexity of the search
# requirements, you might want to implement more advanced search features such as
# using full-text search capabilities of the database.
