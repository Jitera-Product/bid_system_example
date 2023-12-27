class AddNameDescriptionToQuestionCategories < ActiveRecord::Migration[6.0]
  def up
    add_column :question_categories, :name, :string
    add_column :question_categories, :description, :text
  end

  def down
    remove_column :question_categories, :name
    remove_column :question_categories, :description
  end
end
