class CreateStudents < ActiveRecord::Migration[6.1]
  def change
    create_table :students do |t|
      t.string :name
      t.string :student_number
      t.references :customer, null: false, foreign_key: true

      t.timestamps
    end
  end
end
