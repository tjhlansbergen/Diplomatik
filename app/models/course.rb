# == Schema Information
#
# Table name: courses
#
#  id          :integer          not null, primary key
#  name        :string
#  code        :string
#  customer_id :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Course < ApplicationRecord
  belongs_to :customer
  has_many :course_qualifications
  has_many :qualifications, :through => :course_qualifications

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :customer
  validates :customer, presence: true
end
