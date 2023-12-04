class CreateKycDocuments < ActiveRecord::Migration[6.0]
  def change
    create_table :kyc_documents do |t|
      t.string :document_type
      t.string :document_file
      t.string :status
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
