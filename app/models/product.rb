class Product < ApplicationRecord
  has_many :bid_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  # Updated relationships
  belongs_to :admin
  belongs_to :user

  # New relationships
  has_many :bid_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  has_one_attached :image, dependent: :destroy

  # validations

  validates :name, presence: true
  validates :name, length: { maximum: 255 }, if: :name?

  validates :price, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 0 }

  validates :description, length: { maximum: 65_535 }, if: :description?

  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                    size: { less_than_or_equal_to: 100.megabytes }

  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # end for validations

  class << self
  end
end
