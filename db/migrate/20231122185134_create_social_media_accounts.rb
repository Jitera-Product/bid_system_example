class CreateSocialMediaAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :social_media_accounts do |t|
      t.string :social_media_platform
      t.string :social_media_id
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
