# == Schema Information
#
# Table name: students
#
#  id             :integer          not null, primary key
#  name           :string
#  student_number :string
#  customer_id    :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Student < ApplicationRecord
  belongs_to :customer
  has_many :student_qualifications
  has_many :qualifications, :through => :student_qualifications

  validates :name, presence: true
  validates :customer, presence: true
  validates :student_number, presence: true
  validates_uniqueness_of :student_number, scope: :customer
end
