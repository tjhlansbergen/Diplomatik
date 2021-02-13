class CreateQualifications < ActiveRecord::Migration[6.1]
  def change
    create_table :qualifications do |t|
      t.string :name
      t.string :organization
      t.references :qualification_type, null: false, foreign_key: true
      t.references :api_user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
