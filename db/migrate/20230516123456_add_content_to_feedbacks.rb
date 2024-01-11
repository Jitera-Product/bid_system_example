class AddContentToFeedbacks < ActiveRecord::Migration[6.0]
  def change
    add_column :feedbacks, :content, :text
  end
end
