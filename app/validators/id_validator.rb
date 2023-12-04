class IdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value.present? && value.is_a?(Integer) && value > 0
      record.errors[attribute] << (options[:message] || "is not a valid id")
    end
  end
end
