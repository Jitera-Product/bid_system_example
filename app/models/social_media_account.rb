class SocialMediaAccount < ApplicationRecord
  belongs_to :user
  # validations
  validates :social_media_platform, presence: true
  validates :social_media_id, presence: true, uniqueness: true
  validates :user_id, presence: true
  # methods
  def self.find_by_social_media_id(social_media_id)
    where(social_media_id: social_media_id).first
  end
end
