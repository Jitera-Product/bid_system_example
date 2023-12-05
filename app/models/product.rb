class Product < ApplicationRecord
  has_many :bid_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  # Updated relationships
  belongs_to :admin
  belongs_to :user

  has_one_attached :image, dependent: :destroy

  # validations

  validates :name, presence: true
  validates :name, length: { in: 0..255 }, if: :name?

  validates :price, presence: true
  # Updated price validation to remove upper limit
  validates :price, numericality: { greater_than_or_equal_to: 0.0 }

  validates :description, length: { in: 0..65_535 }, if: :description?

  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                    size: { less_than_or_equal_to: 100.megabytes }

  # Updated stock validation to remove upper limit
  validates :stock, numericality: { greater_than_or_equal_to: 0 }

  # end for validations

  class << self
  end
end
