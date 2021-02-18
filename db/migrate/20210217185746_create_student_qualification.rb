class CreateStudentQualification < ActiveRecord::Migration[6.1]
  def change
    create_table :student_qualifications, :id => false do |t|
      t.references :student, null: false, foreign_key: true
      t.references :qualification, null: false, foreign_key: true

    end
  end
end
