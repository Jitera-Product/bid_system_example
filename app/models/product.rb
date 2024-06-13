class Product < ApplicationRecord
  has_many :bid_items, dependent: :destroy
  has_many :product_categories, dependent: :destroy

  belongs_to :user
  belongs_to :aproved,
             class_name: 'Admin'

  has_one_attached :image, dependent: :destroy

  # validations

  validates :name, presence: true, length: { maximum: 255 }

  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0.0 }, format: { with: /\A\d+(?:\.\d{0,2})?\z/ }

  validates :description, length: { maximum: 65_535 }, allow_blank: true

  validates :image, content_type: ['image/png', 'image/jpg', 'image/jpeg', 'image/gif', 'image/svg+xml'],
                    size: { less_than_or_equal_to: 100.megabytes }

  validates :stock, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # end for validations

  class << self
  end
end