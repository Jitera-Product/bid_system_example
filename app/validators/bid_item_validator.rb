class BidItemValidator < ActiveModel::Validator
  def validate(record)
    unless record.id.present? && record.id.is_a?(Integer)
      record.errors.add(:id, "Wrong format")
    end
    unless BidItem.find_by(id: record.id)
      record.errors.add(:id, "This bid item is not found")
    end
    unless record.name.present? && record.name.length <= 100
      record.errors.add(:name, "You cannot input more 100 characters")
    end
    unless record.description.present? && record.description.length <= 1000
      record.errors.add(:description, "You cannot input more 1000 characters")
    end
    unless record.start_price.present? && record.start_price.is_a?(Float)
      record.errors.add(:start_price, "Wrong format")
    end
    unless record.current_price.present? && record.current_price.is_a?(Float)
      record.errors.add(:current_price, "Wrong format")
    end
    unless record.status.present? && ['active', 'inactive', 'sold'].include?(record.status)
      record.errors.add(:status, "Invalid status")
    end
  end
end
