class Course < ApplicationRecord
  belongs_to :customer
  has_many :course_qualifications
  has_many :qualifications, :through => :course_qualifications

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :customer
  validates :customer, presence: true
end
