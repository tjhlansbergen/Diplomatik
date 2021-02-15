class CreateCustomerQualifications < ActiveRecord::Migration[6.1]
  def change
    create_table :customer_qualifications, :id => false do |t|
      t.references :customer, null: false, foreign_key: true
      t.references :qualification, null: false, foreign_key: true
    end
  end
end
