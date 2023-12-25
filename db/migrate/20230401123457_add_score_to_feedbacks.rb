class AddScoreToFeedbacks < ActiveRecord::Migration[6.0]
  def up
    add_column :feedbacks, :score, :integer
  end

  def down
    remove_column :feedbacks, :score
  end
end
