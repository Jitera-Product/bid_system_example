class PaymentMethod < ApplicationRecord
  belongs_to :user

  has_one :withdrawal, dependent: :destroy

  has_many :deposits, dependent: :destroy

  enum method: %w[paypal usdt stripe], _suffix: true

  # validations

  # end for validations

  class << self
  end
end
