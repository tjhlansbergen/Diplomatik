# == Schema Information
#
# Table name: qualifications
#
#  id                    :integer          not null, primary key
#  name                  :string
#  organization          :string
#  qualification_type_id :integer          not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
class Qualification < ApplicationRecord
  belongs_to :qualification_type
  has_many :customer_qualifications
  has_many :customers, :through => :customer_qualifications
  has_many :course_qualifications
  has_many :courses, :through => :course_qualifications
  has_many :student_qualifications
  has_many :students, :through => :student_qualifications
  

  validates :name, presence: true
  validates_uniqueness_of :name, scope: :organization
  validates :organization, presence: true
end
