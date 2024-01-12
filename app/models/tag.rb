
class Tag < ApplicationRecord
  # existing code

  def self.validate_tag_ids(tag_ids)
    tag_ids.all? do |tag_id|
      exists?(tag_id)
    end
  end
end
