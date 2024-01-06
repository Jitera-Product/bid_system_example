class UserSession < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :token, presence: true
  validates :expires_at, presence: true
  validates :user_id, presence: true

  # Callbacks
  before_create :generate_token

  private

  def generate_token
    self.token = SecureRandom.hex(10) # or another token generation method
  end
end
