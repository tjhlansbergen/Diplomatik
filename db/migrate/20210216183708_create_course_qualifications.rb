class CreateCourseQualifications < ActiveRecord::Migration[6.1]
  def change
    create_table :course_qualifications do |t|
      t.references :course, null: false, foreign_key: true
      t.references :qualification, null: false, foreign_key: true

    end
  end
end
