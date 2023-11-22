class Shipping < ApplicationRecord
  belongs_to :bid

  enum status: %w[new queue inprogress done], _suffix: true

  # validations

  validates :post_code, numericality: { greater_than_or_equal_to: 0.0, less_than_or_equal_to: 0.0 }

  validates :full_name, presence: true

  validates :full_name, length: { in: 0..255 }, if: :full_name?

  validates :phone_number, presence: true

  validates :phone_number, length: { in: 0..0 }, if: :phone_number?

  validates :phone_number, format: { with: /\A(([+]{1}\d{2})\d{10,12}|\d{11,13})\z/ }

  validates :email, presence: true

  validates :email, length: { in: 0..0 }, if: :email?

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  validates :shiping_address, presence: true

  validates :shiping_address, length: { in: 0..255 }, if: :shiping_address?

  # end for validations

  class << self
  end
end
