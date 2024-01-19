class Category < ApplicationRecord
  # Existing relationships
  has_many :product_categories, dependent: :destroy
  has_many :questions, dependent: :destroy # New relationship with questions

  # Updated relationship with Admin
  belongs_to :admin

  # Existing validations
  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  # New validation for disabled
  validates :disabled, inclusion: { in: [true, false] }

  # Existing class methods and any other code
  class << self
    # ...
  end
end
