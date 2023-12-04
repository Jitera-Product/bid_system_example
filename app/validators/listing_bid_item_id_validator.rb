class ListingBidItemIdValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    unless value =~ /\A\d+\z/
      record.errors[attribute] << (options[:message] || "Wrong format")
    end
    unless ListingBidItem.exists?(value)
      record.errors[attribute] << "This listing bid item is not found"
    end
  end
end
