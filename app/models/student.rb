class Student < ApplicationRecord
  belongs_to :customer
  has_many :student_qualifications
  has_many :qualifications, :through => :student_qualifications

  validates :name, presence: true
  validates :customer, presence: true
  validates :student_number, presence: true
  validates_uniqueness_of :student_number, scope: :customer
end
