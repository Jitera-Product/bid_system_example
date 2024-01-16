
class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :content

  # Add any custom methods below if required
  # For example, you can add a method to format the content if needed
end
