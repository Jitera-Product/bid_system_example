# typed: strict
class Moder < ApplicationRecord
  # Add validations here based on the column validation options provided in the "# TABLE" section.
  # For example, for encrypted_password:
  validates :encrypted_password, length: { maximum: 255 }, allow_nil: true
  validates :email, length: { maximum: 255 }, allow_nil: true
  validates :reset_password_token, length: { maximum: 255 }, allow_nil: true
  # No validation needed for reset_password_sent_at as there are no specific requirements
  # No validation needed for remember_created_at as there are no specific requirements
  # No validation needed for current_sign_in_at as there are no specific requirements
  # No validation needed for last_sign_in_at as there are no specific requirements
  validates :current_sign_in_ip, length: { maximum: 255 }, allow_nil: true
  validates :last_sign_in_ip, length: { maximum: 255 }, allow_nil: true
  validates :sign_in_count, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :password, length: { maximum: 255 }, allow_nil: true
  validates :password_confirmation, length: { maximum: 255 }, allow_nil: true
  # No validation needed for locked_at as there are no specific requirements
  validates :failed_attempts, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
  validates :unlock_token, length: { maximum: 255 }, allow_nil: true
  validates :confirmation_token, length: { maximum: 255 }, allow_nil: true
  validates :unconfirmed_email, length: { maximum: 255 }, allow_nil: true
  # No validation needed for confirmed_at as there are no specific requirements
  # No validation needed for confirmation_sent_at as there are no specific requirements
end
