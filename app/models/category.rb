class Category < ApplicationRecord
  # Existing relationships
  has_many :product_categories, dependent: :destroy
  has_many :todo_categories, dependent: :destroy # Added relationship for todo_categories

  # Updated relationship for admin
  belongs_to :admin, optional: true # Updated to reflect the correct relationship with admin

  # Existing validations
  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  # New validation for disabled
  validates :disabled, inclusion: { in: [true, false] } # Ensure disabled is a boolean

  # Existing class methods and any additional code
  class << self
    # ...
  end
end
